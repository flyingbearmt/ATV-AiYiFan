// GroupListViewModel.swift
import Foundation

class GroupListViewModel: ObservableObject {
    @Published var groups: [Group] = [
        Group(id: "movie", name: "电影"),
        Group(id: "tv", name: "电视剧")
    ]
}

struct Group: Identifiable, Hashable {
    let id: String
    let name: String
}