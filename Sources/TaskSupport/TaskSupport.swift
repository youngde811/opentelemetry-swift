/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

#if os(iOS) || os(macOS) || os(tvOS)

import os.activity

public typealias activity_id_t = os_activity_id_t
public typealias parent_activity_id_t = os_activity_id_t
public typealias activity_scope_state_s = os_activity_scope_state_s

#else

public typealias thread_id_t = UInt
public typealias activity_id_t = UInt
public typealias parent_activity_id_t = UInt  // there's no way to obtain a context parent on Linux
public typealias activity_scope_state_s = UInt  // this is an opaque structure on MacOS

#endif

public class TaskSupport {
    #if os(iOS) || os(macOS) || os(tvOS)
    static public let instance = AppleTaskSupport()
    #else
    static public let instance = LinuxTaskSupport()
    #endif

    public func getIdentifiers() -> (activity_id_t, parent_activity_id_t) {
        return TaskSupport.instance.getIdentifiers()
    }

    public func getCurrentIdentifier() -> activity_id_t {
        return TaskSupport.instance.getCurrentIdentifier()
    }

    public func createActivityContext() -> (activity_id_t, ScopeElement) {
        return TaskSupport.instance.createActivityContext()
    }

    public func leaveScope(scope: ScopeElement) {
        TaskSupport.instance.leaveScope(scope: scope)
    }
}
