// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "opentelemetry-swift",
  products: [
    .library(name: "TaskSupport", targets: ["TaskSupport"]),
    .library(name: "OpenTelemetryApi", type: .static, targets: ["OpenTelemetryApi"]),
    .library(name: "OpenTelemetrySdk", type: .static, targets: ["OpenTelemetrySdk"]),
    .library(name: "ResourceExtension", type: .static, targets: ["ResourceExtension"]),
    .library(name: "URLSessionInstrumentation", type: .static, targets: ["URLSessionInstrumentation"]),
    .library(name: "SignPostIntegration", type: .static, targets: ["SignPostIntegration"]),
    .library(name: "ZipkinExporter", type: .static, targets: ["ZipkinExporter"]),
    .library(name: "StdoutExporter", type: .static, targets: ["StdoutExporter"]),
    .library(name: "PrometheusExporter", type: .static, targets: ["PrometheusExporter"]),
    .library(name: "OpenTelemetryProtocolExporter", type: .static, targets: ["OpenTelemetryProtocolExporterGrpc"]),
    .library(name: "OpenTelemetryProtocolExporterHTTP", type: .static, targets: ["OpenTelemetryProtocolExporterHttp"]),
    .library(name: "PersistenceExporter", type: .static, targets: ["PersistenceExporter"]),
    .library(name: "InMemoryExporter", type: .static, targets: ["InMemoryExporter"]),
    .library(name: "NetworkStatus", type: .static, targets: ["NetworkStatus"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
    .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.20.2"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.4"),
    .package(url: "https://github.com/apple/swift-metrics.git", from: "2.1.1"),
    .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0"),
  ],
  targets: [
    .target(
      name: "TaskSupport",
      dependencies: []
    ),
    .target(name: "OpenTelemetryApi",
            dependencies: [
              "TaskSupport"
            ]
    ),
    .target(name: "OpenTelemetrySdk",
            dependencies: [
              "OpenTelemetryApi"
            ]
    ),
    .target(name: "ResourceExtension",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Instrumentation/SDKResourceExtension",
            exclude: ["README.md"]),
    .target(name: "URLSessionInstrumentation",
            dependencies: ["OpenTelemetrySdk", "NetworkStatus"],
            path: "Sources/Instrumentation/URLSession",
            exclude: ["README.md"]),
    .target(name: "NetworkStatus",
            dependencies: [
              "OpenTelemetryApi",
              .product(name: "Reachability", package: "Reachability.swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst]))
            ],
            path: "Sources/Instrumentation/NetworkStatus",
            linkerSettings: [.linkedFramework("CoreTelephony", .when(platforms: [.iOS], configuration: nil))]),
    .target(name: "SignPostIntegration",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Instrumentation/SignPostIntegration",
            exclude: ["README.md"]),
    .target(name: "ZipkinExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/Zipkin"),
    .target(name: "PrometheusExporter",
            dependencies: ["OpenTelemetrySdk",
                           .product(name: "NIO", package: "swift-nio"),
                           .product(name: "NIOHTTP1", package: "swift-nio")],
            path: "Sources/Exporters/Prometheus"),
    .target(name: "OpenTelemetryProtocolExporterCommon",
            dependencies: ["OpenTelemetrySdk",
                           .product(name: "Logging", package: "swift-log"),
                           .product(name: "SwiftProtobuf", package: "swift-protobuf")],
            path: "Sources/Exporters/OpenTelemetryProtocolCommon"),
    .target(name: "OpenTelemetryProtocolExporterHttp",
            dependencies: ["OpenTelemetrySdk",
                           "OpenTelemetryProtocolExporterCommon"],
            path: "Sources/Exporters/OpenTelemetryProtocolHttp"),
    .target(name: "OpenTelemetryProtocolExporterGrpc",
            dependencies: ["OpenTelemetrySdk",
                           "OpenTelemetryProtocolExporterCommon",
                           .product(name: "GRPC", package: "grpc-swift")],
            path: "Sources/Exporters/OpenTelemetryProtocolGrpc"),
    .target(name: "StdoutExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/Stdout"),
    .target(name: "InMemoryExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/InMemory"),
    .target(name: "PersistenceExporter",
            dependencies: ["OpenTelemetrySdk"],
            path: "Sources/Exporters/Persistence"),
    .testTarget(name: "OpenTelemetryApiTests",
                dependencies: ["OpenTelemetryApi"],
                path: "Tests/OpenTelemetryApiTests"),
    .testTarget(name: "OpenTelemetrySdkTests",
                dependencies: ["OpenTelemetryApi",
                               "OpenTelemetrySdk"],
                path: "Tests/OpenTelemetrySdkTests"),
    .testTarget(name: "ResourceExtensionTests",
                dependencies: ["ResourceExtension", "OpenTelemetrySdk"],
                path: "Tests/InstrumentationTests/SDKResourceExtensionTests"),
    .testTarget(name: "URLSessionInstrumentationTests",
                dependencies: ["URLSessionInstrumentation",
                               .product(name: "NIO", package: "swift-nio"),
                               .product(name: "NIOHTTP1", package: "swift-nio")],
                path: "Tests/InstrumentationTests/URLSessionTests"),
    .testTarget(name: "ZipkinExporterTests",
                dependencies: ["ZipkinExporter"],
                path: "Tests/ExportersTests/Zipkin"),
    .testTarget(name: "PrometheusExporterTests",
                dependencies: ["PrometheusExporter"],
                path: "Tests/ExportersTests/Prometheus"),
    .testTarget(name: "OpenTelemetryProtocolExporterTests",
                dependencies: ["OpenTelemetryProtocolExporterGrpc",
                               "OpenTelemetryProtocolExporterHttp",
                               .product(name: "NIO", package: "swift-nio"),
                               .product(name: "NIOHTTP1", package: "swift-nio"),
                               .product(name: "NIOTestUtils", package: "swift-nio")],
                path: "Tests/ExportersTests/OpenTelemetryProtocol"),
    .testTarget(name: "InMemoryExporterTests",
                dependencies: ["InMemoryExporter"],
                path: "Tests/ExportersTests/InMemory"),
    .testTarget(name: "PersistenceExporterTests",
                dependencies: ["PersistenceExporter"],
                path: "Tests/ExportersTests/PersistenceExporter"),
  ]
)
