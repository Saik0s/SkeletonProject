//
// Workspace.swift
//

import ProjectDescription

let workspace = Workspace(
  name: "SkeletonProject",
  projects: ["."],
  generationOptions: .options(
    lastXcodeUpgradeCheck: Version(15, 4, 0)
  )
)
