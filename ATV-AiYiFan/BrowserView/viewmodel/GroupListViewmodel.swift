// GroupListViewModel.swift
import Foundation

class GroupListViewModel: ObservableObject {
@Published var groups: [Group] = [
        Group(id: 1, name: "全部版块", groupPathId: "0.1.3", slug: "all", imageTag: "box.truck"),
        Group(id: 2, name: "电影", groupPathId: "0.1.4", slug: "movie", imageTag: "popcorn.fill"),
        Group(id: 3, name: "电视剧", groupPathId: "0.1.5", slug: "tv", imageTag: "airplane.departure"),
        Group(id: 4, name: "综艺", groupPathId: "0.1.6", slug: "variety", imageTag: "sofa"),
        Group(id: 5, name: "动漫", groupPathId: "0.1.7", slug: "anime", imageTag: "box.truck"),
        Group(id: 6, name: "短剧", groupPathId: "0.1.8", slug: "short", imageTag: "box.truck"),
        Group(id: 7, name: "体育", groupPathId: "0.1.9", slug: "sports", imageTag: "sportscourt.fill"),
        Group(id: 8, name: "纪录片", groupPathId: "0.1.10", slug: "documentary", imageTag: "film.circle"),
        Group(id: 9, name: "华人", groupPathId: "0.1.11", slug: "chinese", imageTag: "box.truck"),
        Group(id: 10, name: "游戏", groupPathId: "0.1.12", slug: "game", imageTag: "gamecontroller"),
        Group(id: 11, name: "新闻", groupPathId: "0.1.13", slug: "news", imageTag: "newspaper.fill"),
        Group(id: 12, name: "娱乐", groupPathId: "0.1.14", slug: "entertainment", imageTag: "box.truck"),
        Group(id: 13, name: "生活", groupPathId: "0.1.15", slug: "life", imageTag: "box.truck"),
        Group(id: 14, name: "音乐", groupPathId: "0.1.16", slug: "music", imageTag: "music.note.list"),
        Group(id: 15, name: "时尚", groupPathId: "0.1.17", slug: "fashion", imageTag: "fleuron.fill"),
        Group(id: 16, name: "科技", groupPathId: "0.1.18", slug: "tech", imageTag: "box.truck"),
        Group(id: 17, name: "发现", groupPathId: "0.1.19", slug: "discovery", imageTag: "box.truck"),
        Group(id: 18, name: "午夜版", groupPathId: "0.1.20", slug: "midnight", imageTag: "box.truck"),
        Group(id: 19, name: "橙果儿童", groupPathId: "0.1.21", slug: "kids", imageTag: "box.truck")
    ]
}

struct Group: Identifiable, Hashable {
    let id: Int
    let name: String
    let groupPathId: String
    let slug: String
    let imageTag: String
}
