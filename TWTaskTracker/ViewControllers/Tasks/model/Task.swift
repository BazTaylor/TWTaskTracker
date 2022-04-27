//
//  Task.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 27/04/2022.
//

import Foundation

class TaskResponse: Codable {
    let tasks: [Task]
//    let meta: Meta
//
//    init(tasks: [Task], meta: Meta) {
//        self.tasks = tasks
//        self.meta = meta
//    }
}

// MARK: - Task
class Task: Codable {
    let id: Int?
//    let name: String
//    let description: String
//    let priority: String?
//    let hasDeskTickets: Bool
//    let progress, displayOrder: Int
//    let crmDealIds: [Int]?
//    let tagIds: [Int]?
//    let updatedAt: Date
//    let updatedBy: Int
//    let parentTask, card: Int?
//    let isPrivate: Int
//    let lockdown: Int?
//    let status: Status
//    let tasklist: Tasklist
//    let taskgroup: Int?
//    let startDate, dueDate: Date?
//    let startDateOffset, dueDateOffset: Int?
//    let estimateMinutes, accumulatedEstimatedMinutes: Int
//    let assignees: [Tasklist]
//    let commentFollowers, changeFollowers, attachments: [Int]
//    let isArchived: Bool
//    let capacities: Int?
//    let userPermissions: UserPermissions
//    let createdBy: Int
//    let createdAt: Date
//    let sequence: Int?
//    let dateUpdated: Date
//    let parentTaskId, tasklistId: Int
//    let assigneeUserIds: [Int]?
//    let assigneeUsers: [Tasklist]
//    let assigneeCompanyIds: Int?
//    let assigneeCompanies: [Int]
//    let assigneeTeamIds: Int?
//    let assigneeTeams: [Int]
//    let createdByUserId: Int
//    let sequenceId: Int?
//    let originalDueDate: String?
}

// MARK: - Tasklist
class Tasklist: Codable {
    let id: Int
    let type: TypeEnum
    
    init(id: Int, type: TypeEnum) {
        self.id = id
        self.type = type
    }
}

enum TypeEnum: String, Codable {
    case tasklists = "tasklists"
    case users = "users"
}

enum Status: String, Codable {
    case new = "new"
    case reopened = "reopened"
}

// MARK: - UserPermissions
class UserPermissions: Codable {
    let canEdit, canComplete, canLogTime, canViewEstTime: Bool
    let canAddSubtasks: Bool
    
    init(canEdit: Bool, canComplete: Bool, canLogTime: Bool, canViewEstTime: Bool, canAddSubtasks: Bool) {
        self.canEdit = canEdit
        self.canComplete = canComplete
        self.canLogTime = canLogTime
        self.canViewEstTime = canViewEstTime
        self.canAddSubtasks = canAddSubtasks
        }
}

// MARK: - Meta
class Meta: Codable {
    let page: Page
    
    init(page: Page) {
        self.page = page
    }
}

// MARK: - Page
class Page: Codable {
    let pageOffset, pageSize, count: Int
    let hasMore: Bool
    
    init(pageOffset: Int, pageSize: Int, count: Int, hasMore: Bool) {
        self.pageOffset = pageOffset
        self.pageSize = pageSize
        self.count = count
        self.hasMore = hasMore
    }
}
