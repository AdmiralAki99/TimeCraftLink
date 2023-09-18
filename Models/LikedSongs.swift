//
//  LikedSongs.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-23.
//

import Foundation

struct LikedSongs : Codable{
    let items : [Track]
}

//{
//    href = "https://api.spotify.com/v1/me/tracks?offset=0&limit=1";
//    items =     (
//                {
//            "added_at" = "2023-08-20T19:56:25Z";
//            track =             {
//                album =                 {
//                    "album_type" = single;
//                    artists =                     (
//                                                {
//                            "external_urls" =                             {
//                                spotify = "https://open.spotify.com/artist/3TAbCYRVx4d1HX3BNfK4KR";
//                            };
//                            href = "https://api.spotify.com/v1/artists/3TAbCYRVx4d1HX3BNfK4KR";
//                            id = 3TAbCYRVx4d1HX3BNfK4KR;
//                            name = "The Year End";
//                            type = artist;
//                            uri = "spotify:artist:3TAbCYRVx4d1HX3BNfK4KR";
//                        }
//                    );
//
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/album/4Ft3QViqXzQtEi7pScuGg3";
//                    };
//                    href = "https://api.spotify.com/v1/albums/4Ft3QViqXzQtEi7pScuGg3";
//                    id = 4Ft3QViqXzQtEi7pScuGg3;
//                    images =                     (
//                                                {
//                            height = 640;
//                            url = "https://i.scdn.co/image/ab67616d0000b273aaef7698dea3a6759199259b";
//                            width = 640;
//                        },
//                                                {
//                            height = 300;
//                            url = "https://i.scdn.co/image/ab67616d00001e02aaef7698dea3a6759199259b";
//                            width = 300;
//                        },
//                                                {
//                            height = 64;
//                            url = "https://i.scdn.co/image/ab67616d00004851aaef7698dea3a6759199259b";
//                            width = 64;
//                        }
//                    );
//                    name = "If It Hadn't Ended Then, It Would've Ended Now (2023)";
//                    "release_date" = "2023-05-19";
//                    "release_date_precision" = day;
//                    "total_tracks" = 1;
//                    type = album;
//                    uri = "spotify:album:4Ft3QViqXzQtEi7pScuGg3";
//                };
//                artists =                 (
//                                        {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/3TAbCYRVx4d1HX3BNfK4KR";
//                        };
//                        href = "https://api.spotify.com/v1/artists/3TAbCYRVx4d1HX3BNfK4KR";
//                        id = 3TAbCYRVx4d1HX3BNfK4KR;
//                        name = "The Year End";
//                        type = artist;
//                        uri = "spotify:artist:3TAbCYRVx4d1HX3BNfK4KR";
//                    }
//                );
//                "disc_number" = 1;
//                "duration_ms" = 266000;
//                explicit = 0;
//                "external_ids" =                 {
//                    isrc = QZHNA2318086;
//                };
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/track/6VRllAKog8Hlnv4IG7iW1x";
//                };
//                href = "https://api.spotify.com/v1/tracks/6VRllAKog8Hlnv4IG7iW1x";
//                id = 6VRllAKog8Hlnv4IG7iW1x;
//                "is_local" = 0;
//                name = "If It Hadn't Ended Then, It Would've Ended Now - 2023";
//                popularity = 35;
//                "preview_url" = "https://p.scdn.co/mp3-preview/3a1df9f6f4b633921defdbfbc95ad4dadf04be22?cid=1518efa088954d2f8e4ae240890bf5c7";
//                "track_number" = 1;
//                type = track;
//                uri = "spotify:track:6VRllAKog8Hlnv4IG7iW1x";
//            };
//        }
//    );
//    limit = 1;
//    next = "https://api.spotify.com/v1/me/tracks?offset=1&limit=1";
//    offset = 0;
//    previous = "<null>";
//    total = 800;
//}
