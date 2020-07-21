//
//  MangaParkWeb.swift
//  manga_comic
//
//  Created by gem on 7/6/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup
import SwiftyJSON

class MangaPark {
    let headers = [
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36",
        "Cookie": "__cfduid=d6aa29a7052af5e2050820eef37a0a92c1594000986; _ga=GA1.2.641518996.1594000989; _gid=GA1.2.1251178024.1594603015; cf_clearance=2a19f7ff467858c2f5265b00f2c8a6b1ed597e1d-1594807603-0-1zedb55dafzff72409cz809c3d3d-150; set=theme=1&h=0&img_load=1&img_zoom=1&img_tool=1&twin_m=0&twin_c=0&manga_a_warn=1&history=1&timezone=14; Hm_lvt_5ee99fa43d3e817978c158dfc8eb72ad=1594703881,1594706188,1594776906,1594862746; _gat_gtag_UA_17788005_10=1; Hm_lpvt_5ee99fa43d3e817978c158dfc8eb72ad=1594872271; __atuvc=333%7C28%2C99%7C29; __atuvs=5f0fd1a90ac3f19d001"
    ]
    
    public func getMangaLatest(page: Int, callback: @escaping ([MangaItem]) -> Void) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/latest/\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        var arrMangaItem = [MangaItem]()
                        let parsed = try SwiftSoup.parse(htmlResult)
                        for e in try parsed.getElementsByClass("ls1")[0].getElementsByClass("item") {
                            arrMangaItem.append(self.parseHtmlListMangaLastest(element: e))
                        }
                        callback(arrMangaItem)
                    } catch {
                        debugPrint(error)
                    }
                } else if response.result.isFailure {
                    debugPrint("time out")
                }
        }
    }
    
    func parseHtmlListMangaLastest(element: Element) -> MangaItem {
        do {
            let name = try element.select("a")[0].attr("title")
            let urlManga = try element.select("a")[0].attr("href")
            let imageUrl = try element.select("a")[0].select("img").attr("src")
            let newChap = try element.select("ul")[0].select("li")[0].select("span")[0].select("a")[0].text()
            return MangaItem.init(name: name, url: "\(Contains.BASE_URL + urlManga)", imageUrl: "https:\(imageUrl)", newChap: newChap)
        } catch {
            debugPrint(error)
            return MangaItem.init(name: "", url: "", imageUrl: "", newChap: "")
        }
    }
    
    public func getMangaHot(page: Int, callback: @escaping ([MangaItem]) -> Void) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/search?orderby=views&page=\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        var arrMangaItem = [MangaItem]()
                        let parsed = try SwiftSoup.parse(htmlResult)
                        for e in try parsed.getElementsByClass("manga-list")[0].getElementsByClass("item") {
                            arrMangaItem.append(self.parseListMangaNewOrHot(element: e))
                        }
                        callback(arrMangaItem)
                    } catch {
                        debugPrint(error)
                    }
                } else if response.result.isFailure {
                    debugPrint("time out")
                }
        }
    }
    
    public func getNewManga(page: Int, callback: @escaping ([MangaItem]) -> Void) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/search?orderby=create&page=\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        var arrMangaItem = [MangaItem]()
                        let parsed = try SwiftSoup.parse(htmlResult)
                        for e in try parsed.getElementsByClass("manga-list")[0].getElementsByClass("item") {
                            arrMangaItem.append(self.parseListMangaNewOrHot(element: e))
                        }
                        callback(arrMangaItem)
                    } catch {
                        debugPrint(error)
                    }
                }
                else if response.result.isFailure {
                    debugPrint("time out")
                }
            }
    }
    
    func parseListMangaNewOrHot(element: Element) -> MangaItem{
        do {
            let name = try element.select("a").attr("title")
            let urlManga = try element.select("a").attr("href")
            let imageUrl = try element.select("a").select("img").attr("src")
            let newChap = try element.select("ul").select("li").select("span").select("a").select("b").text()
            return MangaItem.init(name: name, url: "\(Contains.BASE_URL + urlManga)", imageUrl: "https:\(imageUrl)", newChap: newChap)
        } catch {
            debugPrint(error)
            return MangaItem.init(name: "", url: "", imageUrl: "", newChap: "")
        }
    }
    
    public func getDetailManga(url: String, callback: @escaping (DetailManga) -> Void) {
        Alamofire.request(url, method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        let detail = self.parseDetailManga(document: parsed)
                        callback(detail)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    public func parseDetailManga(document: Document) -> DetailManga {
        do {
            var arrChapter = [VolumAndChap]()
            let elements = try document.select("tr")
            let ratingStar = try elements[0].select("td").text()
            let ratingOverview = try elements[1].select("td").text()
            let popularity = try elements[2].select("td").text()
            let alternative = try elements[3].select("td").text()
            let author = try elements[4].select("td").text()
            let artist = try elements[5].select("td").text()
            let genre = try elements[6].select("td").text()
            let type = try elements[7].select("td").text()
            var status = ""
            var mergeBy = ""
            var lastest = ""
            if try elements[8].select("th").text() != "Release" {
                status = try elements[8].select("td").text()
                mergeBy = try elements[9].select("td").text()
                lastest = try elements[10].select("td").text()
            } else {
                status = try elements[9].select("td").text()
                mergeBy = try elements[10].select("td").text()
                lastest = try elements[11].select("td").text()
            }
            let summary = try document.getElementsByClass("summary").text()
            let blockChapter = try document.getElementsByClass("mt-2 volume")[0]
            for i in 0...(try blockChapter.getElementsByClass("d-none d-md-block").count - 1) {
                let nameChapter = try blockChapter.getElementsByClass("ml-1 visited ch")[i].text()
                let urlChapter = try blockChapter.getElementsByClass("d-none d-md-block")[i].select("a")[4].attr("href")
                arrChapter.append(VolumAndChap.init(name: nameChapter, urlVolumAndChap: Contains.BASE_URL + urlChapter))
            }
            
            return DetailManga.init(rating: ratingStar, ratingOverview: ratingOverview, popularity: popularity, alternative: alternative, authors: author, artist: artist, genre: genre, type: type, status: status, mergeBy: mergeBy, lastest: lastest, summary: summary, volumAndChap: arrChapter)
        } catch {
            debugPrint(error)
        }
        return DetailManga.init()
    }
    
    public func getListImageChapter(url: String, callback: @escaping ([String]) -> Void) {
        Alamofire.request(url, method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        let script = try parsed.select("script")[4].data()
                        let start = script.firstIndex(of: "[")!
                        let end = script.lastIndex(of: "]")!
                        let arrCommic = script[start...end]
                        let data = Data(arrCommic.utf8)
                        let json = try JSON(data: data)
                        var stringArr = [String]()
                        if let items = json.array {
                            for item in items {
                                stringArr.append(item["u"].stringValue)
//                                ContentChapterViewController.listImageOfChapter.append(item["u"].stringValue)
                            }
                        }
                        callback(stringArr)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    public func search(orderBy: String, page: Int, callback: @escaping ([MangaItem]) -> Void) {
        var genres = ""
        var rating = ""
        var year = ""
        if SearchViewController.yearSearch == "null" {
            year = ""
        } else {
            year = SearchViewController.yearSearch
        }
        if SearchViewController.rating > 0 {
            rating = "\(SearchViewController.rating)"
        } else {
            rating = ""
        }
        for i in SearchViewController.arrIndexGenreSelected {
            genres += "\(Contains.arrGenre[i]),"
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/search?orderby=\(orderBy)&q=\(SearchViewController.nameKeyWord)&autart=\(SearchViewController.authKeyWord)&genres=\(genres)&rating=\(rating)&status=\(SearchViewController.status)&years=\(year)&page=\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        var arrMangaItem = [MangaItem]()
                        let parsed = try SwiftSoup.parse(htmlResult)
                        for item in try parsed.getElementsByClass("item") {
                            arrMangaItem.append(self.parseListMangaNewOrHot(element: item))
                        }
                        callback(arrMangaItem)
                    } catch {
                        debugPrint(error)
                    }
                }
                else if response.result.isFailure {
                    debugPrint("time out")
                }
        }
    }
}
