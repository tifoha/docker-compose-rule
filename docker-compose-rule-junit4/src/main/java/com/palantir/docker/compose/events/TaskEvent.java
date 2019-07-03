/*
 * (c) Copyright 2019 Palantir Technologies Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.palantir.docker.compose.events;

/**
 * A set of marker interfaces for events that represent tasks - ie those that start then eventually succeeded or fail.
 */
public interface TaskEvent extends DockerComposeRuleEvent {
    interface Started extends TaskEvent {}

    interface Succeeded extends TaskEvent {}

    interface Failed extends TaskEvent {
        Exception exception();
    }

    interface Factory {
        Started started();
        Succeeded succeeded();
        Failed failed(Exception exception);
    }
}
