//
//  NextSongChooser.swift
//  LocalMusicPlayer
//
//  Created by Daisuke Shiraishi on 2018/08/31.
//  Copyright © 2018年 Daisuke Shiraishi. All rights reserved.
//

import MediaPlayer

class NextSongChooser {

    func choose(nowPlayingUrl: URL? = nil) -> MPMediaItem? {
        // 再生中の曲がある場合は、アルバムの次の曲を再生する
        return getMediaItemWith(assetUrl: nowPlayingUrl)
    }

    /**
    assetURLからクエリを作ってMPMediaItemを取得する場合は、通常下記のようにすると思うが落ちてしまう。

    let predicate = MPMediaPropertyPredicate(
        value: url,
        forProperty: MPMediaItemPropertyAssetURL,
        comparisonType: MPMediaPredicateComparison.contains
    )
    let query = MPMediaQuery(predicate: [predicate])
    let items = query.items <- ここで下記エラーが発生

    エラー
    Assertion failure in -[ML3ComparisonPredicate valueToBindForOperation:], /BuildRoot/Library/Caches/com.apple.xbs/Sources/MusicLibrary/MusicLibrary-4015.700.3/MusicLibrary/Framework/Queries/ML3Predicate.m:650
    2018-09-08 17:31:11.898130+0900 LocalMusicPlayer[9272:6376211] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: ''

    他にも困っている人がおり、iOSのバグなんじゃないかと思う。
    https://stackoverflow.com/questions/47220128/mpmediaquery-throws-exception-when-addfilterpredicate-by-asset-url?rq=1

    ワークアラウンドとして、assetURLのidから取得する方法があるようなので、それで実装。
    https://stackoverflow.com/questions/36703059/how-to-get-media-item-from-asset-url/36703342#36703342
    */
    private func getMediaItemWith(assetUrl: URL?) -> MPMediaItem? {
        // AssetUrlは以下のようになっている。ここからid部分を取り出す。
        // ipod-library://item/item.mp3?id=4867477884593097036
        guard let urlStr = assetUrl?.absoluteString, let equalIndex = urlStr.lastIndex(of: "=") else { return nil }
        let id = urlStr[urlStr.index(equalIndex, offsetBy: 1)...]
        Log.d("Song ID :\(id)");
        let predicate = MPMediaPropertyPredicate(
            value: id,
            forProperty: MPMediaItemPropertyPersistentID,
            comparisonType: MPMediaPredicateComparison.contains);
        let query = MPMediaQuery(filterPredicates: [predicate])
        return query.items?.first
    }
}
