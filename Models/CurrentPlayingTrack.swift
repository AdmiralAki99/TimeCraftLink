//
//  CurrentPlayingTrack.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-29.
//

import Foundation

struct CurrentPlayingTrack : Codable{
    let currently_playing_type : String?
    let progress_ms : Int64?
    let is_playing : Bool?
    let item : Track?
}

//{
//    item =     {
//        album =         {
//            "album_type" = single;
//            artists =             (
//                {
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/artist/6MDME20pz9RveH9rEXvrOM";
//                    };
//                    href = "https://api.spotify.com/v1/artists/6MDME20pz9RveH9rEXvrOM";
//                    id = 6MDME20pz9RveH9rEXvrOM;
//                    name = "Clean Bandit";
//                    type = artist;
//                    uri = "spotify:artist:6MDME20pz9RveH9rEXvrOM";
//                }
//            );
//            "external_urls" =             {
//                spotify = "https://open.spotify.com/album/4UB0J5V3JsZZtNR360pZ6r";
//            };
//            href = "https://api.spotify.com/v1/albums/4UB0J5V3JsZZtNR360pZ6r";
//            id = 4UB0J5V3JsZZtNR360pZ6r;
//            images =             (
//                {
//                    height = 640;
//                    url = "https://i.scdn.co/image/ab67616d0000b2737e519297d9876b6afff2ab7b";
//                    width = 640;
//                },
//                {
//                    height = 300;
//                    url = "https://i.scdn.co/image/ab67616d00001e027e519297d9876b6afff2ab7b";
//                    width = 300;
//                },
//                {
//                    height = 64;
//                    url = "https://i.scdn.co/image/ab67616d000048517e519297d9876b6afff2ab7b";
//                    width = 64;
//                }
//            );
//            name = "Rather Be (feat. Jess Glynne)";
//            "release_date" = "2014-01-17";
//            "release_date_precision" = day;
//            "total_tracks" = 1;
//            type = album;
//            uri = "spotify:album:4UB0J5V3JsZZtNR360pZ6r";
//        };
//        artists =         (
//            {
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/artist/6MDME20pz9RveH9rEXvrOM";
//                };
//                href = "https://api.spotify.com/v1/artists/6MDME20pz9RveH9rEXvrOM";
//                id = 6MDME20pz9RveH9rEXvrOM;
//                name = "Clean Bandit";
//                type = artist;
//                uri = "spotify:artist:6MDME20pz9RveH9rEXvrOM";
//            },
//            {
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/artist/4ScCswdRlyA23odg9thgIO";
//                };
//                href = "https://api.spotify.com/v1/artists/4ScCswdRlyA23odg9thgIO";
//                id = 4ScCswdRlyA23odg9thgIO;
//                name = "Jess Glynne";
//                type = artist;
//                uri = "spotify:artist:4ScCswdRlyA23odg9thgIO";
//            }
//        );
//        "available_markets" =         (
//            AR,
//            AU,
//            AT,
//            BE,
//            BO,
//            BR,
//            BG,
//            CA,
//            CL,
//            CO,
//            CR,
//            CY,
//            CZ,
//            DK,
//            DO,
//            DE,
//            EC,
//            EE,
//            SV,
//            FI,
//            FR,
//            GR,
//            GT,
//            HN,
//            HK,
//            HU,
//            IS,
//            IE,
//            IT,
//            LV,
//            LT,
//            LU,
//            MY,
//            MT,
//            MX,
//            NL,
//            NZ,
//            NI,
//            NO,
//            PA,
//            PY,
//            PE,
//            PH,
//            PL,
//            PT,
//            SG,
//            SK,
//            ES,
//            SE,
//            CH,
//            TW,
//            TR,
//            UY,
//            US,
//            GB,
//            AD,
//            MC,
//            ID,
//            JP,
//            TH,
//            VN,
//            RO,
//            IL,
//            ZA,
//            SA,
//            AE,
//            BH,
//            QA,
//            OM,
//            KW,
//            EG,
//            MA,
//            DZ,
//            TN,
//            LB,
//            JO,
//            IN,
//            BY,
//            KZ,
//            MD,
//            UA,
//            AL,
//            BA,
//            HR,
//            ME,
//            MK,
//            RS,
//            SI,
//            KR,
//            BD,
//            PK,
//            LK,
//            GH,
//            KE,
//            NG,
//            TZ,
//            UG,
//            AG,
//            AM,
//            BS,
//            BB,
//            BZ,
//            BW,
//            BF,
//            CV,
//            CW,
//            DM,
//            FJ,
//            GM,
//            GD,
//            GW,
//            HT,
//            JM,
//            LS,
//            LR,
//            MW,
//            ML,
//            FM,
//            NA,
//            NE,
//            PG,
//            SM,
//            ST,
//            SN,
//            SC,
//            SL,
//            KN,
//            LC,
//            VC,
//            TL,
//            TT,
//            AZ,
//            BN,
//            BI,
//            KH,
//            CM,
//            TD,
//            KM,
//            GQ,
//            SZ,
//            GA,
//            GN,
//            KG,
//            LA,
//            MO,
//            MR,
//            MN,
//            NP,
//            RW,
//            TG,
//            UZ,
//            ZW,
//            BJ,
//            MG,
//            MU,
//            MZ,
//            AO,
//            CI,
//            DJ,
//            ZM,
//            CD,
//            CG,
//            IQ,
//            LY,
//            TJ,
//            VE,
//            ET,
//            XK
//        );
//        "disc_number" = 1;
//        "duration_ms" = 227833;
//        explicit = 0;
//        "external_ids" =         {
//            isrc = GBAHS1300498;
//        };
//        "external_urls" =         {
//            spotify = "https://open.spotify.com/track/3s4U7OHV7gnj42VV72eSZ6";
//        };
//        href = "https://api.spotify.com/v1/tracks/3s4U7OHV7gnj42VV72eSZ6";
//        id = 3s4U7OHV7gnj42VV72eSZ6;
//        "is_local" = 0;
//        name = "Rather Be (feat. Jess Glynne)";
//        popularity = 74;
//        "preview_url" = "https://p.scdn.co/mp3-preview/358cc2906abb9789b9c1d4a7e07dc2601b7ade4b?cid=1518efa088954d2f8e4ae240890bf5c7";
//        "track_number" = 1;
//        type = track;
//        uri = "spotify:track:3s4U7OHV7gnj42VV72eSZ6";
//    };
//    "progress_ms" = 41852;
//    timestamp = 1693330268226;
//}
