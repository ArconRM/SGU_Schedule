//
//  GroupCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.09.2024.
//

import Foundation

struct GroupCoreDataManager: GroupPersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func saveItem(_ itemDto: AcademicGroupDTO) throws -> AcademicGroup {
        do {
            let group = AcademicGroup(context: viewContext)
            group.fullNumber = itemDto.fullNumber
            group.departmentCode = itemDto.departmentCode
            group.isFavourite = false
            
            try viewContext.save()
            return group
        }
        catch {
            print(error.localizedDescription)
            throw CoreDataError.failedToSave
        }
    }
    
    func fetchAllItems() throws -> [AcademicGroup] {
        do {
            if try viewContext.count(for: AcademicGroup.fetchRequest()) == 0 {
                return []
            }
            
            let groups = try viewContext.fetch(AcademicGroup.fetchRequest())
            return groups
        } catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func fetchAllItemsDTO() throws -> [AcademicGroupDTO] {
        do {
            if try viewContext.count(for: AcademicGroup.fetchRequest()) == 0 {
                return []
            }
            
            let managedGroups = try viewContext.fetch(AcademicGroup.fetchRequest())
            var resultGroups = [AcademicGroupDTO]()
            
            for managedGroup in managedGroups {
                let groupDto = AcademicGroupDTO(
                    fullNumber: managedGroup.fullNumber ?? "Error",
                    departmentCode: managedGroup.departmentCode ?? "Error"
                )
                resultGroups.append(groupDto)
            }
            
            return resultGroups
            
        } catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func getFavouriteGroupDTO() throws -> AcademicGroupDTO? {
        do {
            if try viewContext.count(for: AcademicGroup.fetchRequest()) == 0 {
                return nil
            }
            
            guard let managedGroup = try viewContext.fetch(AcademicGroup.fetchRequest()).first(where: { $0.isFavourite }) else {
                return nil
            }
            
            return AcademicGroupDTO(
                fullNumber: managedGroup.fullNumber ?? "Error",
                departmentCode: managedGroup.departmentCode ?? "Error"
            )
        } catch {
            throw CoreDataError.failedToFetch
        }
    }
    
    func clearAllItems() throws {
        do {
            if try viewContext.count(for: AcademicGroup.fetchRequest()) == 0 {
                return
            }
            
            let prevGroups = try self.fetchAllItems()
            for group in prevGroups {
                viewContext.delete(group)
            }
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToDelete
        }
    }
    
    func deleteItemById(_ groupId: String) throws {
        do {
            if try viewContext.count(for: AcademicGroup.fetchRequest()) == 0 {
                return
            }
            
            guard let groupToDelete = try viewContext.fetch(AcademicGroup.fetchRequest()).first(where: { $0.groupId == groupId }) else {
                return
            }
            viewContext.delete(groupToDelete)
            
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToDelete
        }
    }
    
    func makeGroupFavourite(_ groupId: String) throws {
        do {
            let allGroups = try fetchAllItems()
            print(allGroups)
            
            guard let managedGroupToBeFavourite = allGroups.first(where: { $0.groupId == groupId }) else {
                throw CoreDataError.failedToUpdate
            }
            
            if let prevFavouriteGroup = allGroups.first(where: { $0.isFavourite }) {
                prevFavouriteGroup.isFavourite = false
            }
            
            managedGroupToBeFavourite.isFavourite = true
            
            try viewContext.save()
        }
        catch {
            throw CoreDataError.failedToUpdate
        }
    }
}
