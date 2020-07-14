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
        "Cookie": "__cfduid=d6aa29a7052af5e2050820eef37a0a92c1594000986; _ga=GA1.2.641518996.1594000989; _gid=GA1.2.679029208.1594000989; set=theme=1&h=0&img_load=1&img_zoom=1&img_tool=1&twin_m=0&twin_c=0&manga_a_warn=1&history=1&timezone=14; cf_clearance=7f95e221263e69a5f774cde60dfacdf2e27d4d44-1594266809-0-1zedb55dafzff72409cz809c3d3d-150; Hm_lvt_5ee99fa43d3e817978c158dfc8eb72ad=1594173173,1594195360,1594257793,1594283983; _gat_gtag_UA_17788005_10=1; Hm_lpvt_5ee99fa43d3e817978c158dfc8eb72ad=1594284649; __atuvc=290%7C28; __atuvs=5f06afecc8d7ba80036"
    ]
    public func loadAfterLauchApp(collectionView: UICollectionView!) {
        getMangaHot(page: 1, collectionView: collectionView)
        getNewManga(page: 1, collectionView: collectionView)
        getMangaLatest(page: 1, collectionView: collectionView)
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
    }
    
    public func getMangaLatest(page: Int, collectionView: UICollectionView!) {
        if page == 1 {
            Contains.arrMangaLastestItem.removeAll()
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/latest/\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    //                    debugPrint(response.result.value!)
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        
                        //debugPrint(try parsed.getElementsByClass("ls1").select("div")[0])
                        for e in try parsed.getElementsByClass("ls1")[0].getElementsByClass("item") {
                            //debugPrint(e)
                            Contains.arrMangaLastestItem.append(self.parseHtmlListMangaLastest(element: e))
                        }
                        Contains.arrCurrentMangaItem = Contains.arrMangaLastestItem
                        collectionView.reloadData()
                        Contains.loadMore = false
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
            //            debugPrint("\(name) \(Contains.BASE_URL + urlManga)  https:\(imageUrl)  \(newChap)")
            return MangaItem.init(name: name, url: "\(Contains.BASE_URL + urlManga)", imageUrl: "https:\(imageUrl)", newChap: newChap)
        } catch {
            debugPrint(error)
            return MangaItem.init(name: "", url: "", imageUrl: "", newChap: "")
        }
    }
    
    public func getMangaHot(page: Int, collectionView: UICollectionView!) {
        if page == 1 {
            Contains.arrMangaHotItem.removeAll()
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/search?orderby=views&page=\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    //                    debugPrint(response.result.value!)
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        
                        //debugPrint(try parsed.getElementsByClass("ls1").select("div")[0])
                        for e in try parsed.getElementsByClass("manga-list")[0].getElementsByClass("item") {
                            //debugPrint(e)
                            Contains.arrMangaHotItem.append(self.parseListMangaNewOrHot(element: e))
                        }
                        Contains.arrCurrentMangaItem = Contains.arrMangaHotItem
                        collectionView.reloadData()
                        Contains.loadMore = false
                    } catch {
                        debugPrint(error)
                    }
                } else if response.result.isFailure {
                    debugPrint("time out")
                }
        }
    }
    
    public func getNewManga(page: Int, collectionView: UICollectionView!) {
        if page == 1 {
            Contains.arrMangaNewItem.removeAll()
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/search?orderby=create&page=\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    //                    debugPrint(response.result.value!)
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        
                        //debugPrint(try parsed.getElementsByClass("ls1").select("div")[0])
                        for e in try parsed.getElementsByClass("manga-list")[0].getElementsByClass("item") {
                            //debugPrint(e)
                            Contains.arrMangaNewItem.append(self.parseListMangaNewOrHot(element: e))
                        }
                        Contains.arrCurrentMangaItem = Contains.arrMangaNewItem
                        collectionView.reloadData()
                        Contains.loadMore = false
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
    
    public func getDetailManga(url: String) {
        Alamofire.request(url, method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    //                    debugPrint(response.result.value!)
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        Contains.currentManga = self.parseDetailManga(document: parsed)
                        Contains.didLoadDetailManga = true
                        NotificationCenter.default.post(name: NSNotification.Name("reloadDetail"), object: nil)
                        
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
//                debugPrint("\(nameChapter)++++\(urlChapter)")
            }
            
            return DetailManga.init(rating: ratingStar, ratingOverview: ratingOverview, popularity: popularity, alternative: alternative, authors: author, artist: artist, genre: genre, type: type, status: status, mergeBy: mergeBy, lastest: lastest, summary: summary, volumAndChap: arrChapter)
        } catch {
            debugPrint(error)
        }
        return DetailManga.init()
    }
    
    public func getListImageChapter(url: String) {
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
                        if let items = json.array {
                            for item in items {
                                Contains.listImageOfChapter.append(item["u"].stringValue)
                            }
                        }
                        Contains.didLoadListImage = true
                        NotificationCenter.default.post(name: NSNotification.Name("reloadContentImage"), object: nil)
                    } catch {
                        debugPrint(error)
                    }
                }
        }
    }
    
    public func search(orderBy: String, page: Int, collection: UICollectionView!) {
        var genres = ""
        var rating = ""
        var year = ""
        if Contains.yearSearch == "null" {
            year = ""
        } else {
            year = Contains.yearSearch
        }
        if page == 1 {
            Contains.arrSearchMangaItem.removeAll()
            collection.reloadData()
        }
        if Contains.rating > 0 {
            rating = "\(Contains.rating)"
        } else {
            rating = ""
        }
        for i in Contains.arrIndexGenreSelected {
            genres += "\(Contains.arrGenre[i]),"
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.request("https://mangapark.net/search?orderby=\(orderBy)&q=\(Contains.nameKeyWord)&autart=\(Contains.authKeyWord)&genres=\(genres)&rating=\(rating)&status=\(Contains.status)&years=\(year)&page=\(page)", method: .get, headers: headers)
            .responseString { response in
                if response.result.isSuccess {
                    let htmlResult = response.result.value!
                    do {
                        let parsed = try SwiftSoup.parse(htmlResult)
                        for item in try parsed.getElementsByClass("item") {
                            Contains.arrSearchMangaItem.append(self.parseListMangaNewOrHot(element: item))
                        }
                        collection.reloadData()
                        Contains.loadMore = false
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
