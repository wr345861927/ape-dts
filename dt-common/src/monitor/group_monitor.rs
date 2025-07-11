use std::collections::HashMap;
use std::sync::Arc;

use async_trait::async_trait;
use tokio::{sync::Mutex, sync::MutexGuard};

use super::counter_type::CounterType;
use super::monitor::Monitor;
use super::time_window_counter::WindowCounterStatistics;
use super::FlushableMonitor;
use crate::log_monitor;
use crate::monitor::counter_type::AggregateType;

#[derive(Clone, Default)]
pub struct GroupMonitor {
    name: String,
    description: String,
    monitors: HashMap<String, Arc<Mutex<Monitor>>>,
    no_window_counter_statistics_map: HashMap<CounterType, HashMap<AggregateType, usize>>,
}

#[async_trait]
impl FlushableMonitor for GroupMonitor {
    async fn flush(&mut self) {
        self.flush().await;
    }
}

impl GroupMonitor {
    pub fn new(name: &str, description: &str) -> Self {
        Self {
            name: name.into(),
            description: description.into(),
            monitors: HashMap::new(),
            no_window_counter_statistics_map: HashMap::new(),
        }
    }

    pub fn add_monitor(&mut self, id: &str, monitor: Arc<Mutex<Monitor>>) {
        self.monitors.insert(id.to_string(), monitor);
    }

    pub async fn remove_monitor(&mut self, id: &str) {
        // keep statistics of no_window counters before removing:
        // eg. 2025-02-18 05:43:37.028889 | pipeline | global | sinked_count | latest=4199364
        if let Some(monitor) = self.monitors.remove(id) {
            let guard = monitor.lock().await;
            Self::refresh_no_window_counter_statistics_map(
                &mut self.no_window_counter_statistics_map,
                &guard,
            );
        }
    }

    fn refresh_no_window_counter_statistics_map(
        no_window_counter_statistics_map: &mut HashMap<CounterType, HashMap<AggregateType, usize>>,
        guard: &MutexGuard<'_, Monitor>,
    ) {
        for (counter_type, counter) in guard.no_window_counters.iter() {
            // let mut aggregate_value_map = HashMap::new();
            for aggregate_type in counter_type.get_aggregate_types().iter() {
                let aggregate_value = match aggregate_type {
                    AggregateType::Latest => counter.value,
                    AggregateType::AvgByCount => counter.avg_by_count(),
                    _ => continue,
                };

                no_window_counter_statistics_map
                    .entry(counter_type.to_owned())
                    .or_default()
                    .entry(aggregate_type.to_owned())
                    .and_modify(|v| *v += aggregate_value)
                    .or_insert(aggregate_value);
            }
        }
    }

    pub async fn flush(&mut self) {
        let mut window_counter_statistics_map: HashMap<CounterType, Vec<WindowCounterStatistics>> =
            HashMap::new();
        let mut no_window_counter_statistics_map = self.no_window_counter_statistics_map.clone();

        for (_, monitor) in self.monitors.iter() {
            let mut guard = monitor.lock().await;
            for (counter_type, counter) in guard.time_window_counters.iter_mut() {
                let statistics = counter.statistics();
                window_counter_statistics_map
                    .entry(counter_type.to_owned())
                    .or_default()
                    .push(statistics);
            }
            Self::refresh_no_window_counter_statistics_map(
                &mut no_window_counter_statistics_map,
                &guard,
            );
        }

        for (counter_type, statistics_vec) in window_counter_statistics_map {
            let mut log = format!("{} | {} | {}", self.name, self.description, counter_type);
            for aggregate_type in counter_type.get_aggregate_types() {
                let mut aggregate_value = 0;
                for statistics in statistics_vec.iter() {
                    aggregate_value += match aggregate_type {
                        AggregateType::AvgByCount => statistics.avg_by_count,
                        AggregateType::AvgBySec => statistics.avg_by_sec,
                        AggregateType::Sum => statistics.sum,
                        AggregateType::MaxBySec => statistics.max_by_sec,
                        AggregateType::MaxByCount => statistics.max,
                        AggregateType::Count => statistics.count,
                        _ => continue,
                    };
                }
                log = format!("{} | {}={}", log, aggregate_type, aggregate_value);
            }
            log_monitor!("{}", log);
        }

        for (counter_type, aggregate_value_map) in no_window_counter_statistics_map.iter_mut() {
            let mut log = format!("{} | {} | {}", self.name, self.description, counter_type);
            for aggregate_type in counter_type.get_aggregate_types().iter() {
                let aggregate_value = aggregate_value_map.get(aggregate_type).unwrap_or(&0);
                log = format!("{} | {}={}", log, aggregate_type, aggregate_value);
            }
            log_monitor!("{}", log);
        }
    }
}
