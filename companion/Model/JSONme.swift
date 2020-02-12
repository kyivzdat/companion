//
//  JSON:me.swift
//  companion
//
//  Created by Vladyslav PALAMARCHUK on 2/7/20.
//  Copyright © 2020 Vladyslav PALAMARCHUK. All rights reserved.
//

import Foundation

/*

{
    "id": 41821,
    "email": "vpalamar@student.unit.ua",
    "login": "vpalamar",
    "first_name": "Vladyslav",
    "last_name": "Palamarchuk",
    "url": "https://api.intra.42.fr/v2/users/vpalamar",
    "phone": "hidden",
    "displayname": "Vladyslav Palamarchuk",
    "image_url": "https://cdn.intra.42.fr/users/vpalamar.jpg",
    "staff?": false,
    "correction_point": 23,
    "pool_month": "august",
    "pool_year": "2018",
    "location": "e1r8p17",
    "wallet": 40,
    "groups": [],
    "cursus_users": [
        {
            "grade": null,
            "level": 2.48,
            "skills": [
                {
                    "id": 1,
                    "name": "Algorithms & AI",
                    "level": 2.57
                },
                {
                    "id": 3,
                    "name": "Rigor",
                    "level": 2.51
                },
                {
                    "id": 4,
                    "name": "Unix",
                    "level": 2.24
                },
                {
                    "id": 7,
                    "name": "Group & interpersonal",
                    "level": 0.15
                }
            ],
            "blackholed_at": null,
            "id": 43737,
            "begin_at": "2018-08-06T05:42:00.000Z",
            "end_at": "2018-08-31T15:42:00.000Z",
            "cursus_id": 4,
            "has_coalition": true,
            "user": {
                "id": 41821,
                "login": "vpalamar",
                "url": "https://api.intra.42.fr/v2/users/vpalamar"
            },
            "cursus": {
                "id": 4,
                "created_at": "2015-05-01T17:46:08.433Z",
                "name": "Piscine C",
                "slug": "piscine-c"
            }
        },
        {
            "grade": "Lieutenant",
            "level": 9.15,
            "skills": [
                {
                    "id": 1,
                    "name": "Algorithms & AI",
                    "level": 10.61
                },
                {
                    "id": 3,
                    "name": "Rigor",
                    "level": 4.26
                },
                {
                    "id": 2,
                    "name": "Imperative programming",
                    "level": 4.18
                },
                {
                    "id": 14,
                    "name": "Adaptation & creativity",
                    "level": 2.9
                },
                {
                    "id": 7,
                    "name": "Group & interpersonal",
                    "level": 2.77
                },
                {
                    "id": 17,
                    "name": "Object-oriented programming",
                    "level": 2.5300000000000002
                },
                {
                    "id": 15,
                    "name": "Technology integration",
                    "level": 2.24
                },
                {
                    "id": 5,
                    "name": "Graphics",
                    "level": 1.28
                },
                {
                    "id": 13,
                    "name": "Organization",
                    "level": 1.21
                },
                {
                    "id": 4,
                    "name": "Unix",
                    "level": 1.17
                },
                {
                    "id": 9,
                    "name": "Parallel computing",
                    "level": 1.03
                },
                {
                    "id": 16,
                    "name": "Company experience",
                    "level": 0.53
                }
            ],
            "blackholed_at": null,
            "id": 51459,
            "begin_at": "2018-10-22T06:42:00.000Z",
            "end_at": null,
            "cursus_id": 1,
            "has_coalition": true,
            "user": {
                "id": 41821,
                "login": "vpalamar",
                "url": "https://api.intra.42.fr/v2/users/vpalamar"
            },
            "cursus": {
                "id": 1,
                "created_at": "2014-11-02T16:43:38.480Z",
                "name": "42",
                "slug": "42"
            }
        }
    ],
    "projects_users": [
        {
            "id": 978028,
            "occurrence": 0,
            "final_mark": 65,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2120329,
            "project": {
                "id": 157,
                "name": "Day 03",
                "slug": "piscine-c-day-03",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-11T18:02:09.310Z",
            "marked": true,
            "retriable_at": "2018-08-11T18:02:09.540Z"
        },
        {
            "id": 1589204,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2844838,
            "project": {
                "id": 754,
                "name": "Day 09",
                "slug": "piscine-swift-ios-day-09",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-15T12:57:02.899Z",
            "marked": true,
            "retriable_at": "2019-10-15T12:57:03.822Z"
        },
        {
            "id": 971552,
            "occurrence": 0,
            "final_mark": 30,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2112500,
            "project": {
                "id": 154,
                "name": "Day 00",
                "slug": "piscine-c-day-00",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-08T17:40:50.012Z",
            "marked": true,
            "retriable_at": "2018-08-08T17:40:50.167Z"
        },
        {
            "id": 974758,
            "occurrence": 0,
            "final_mark": 40,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2117007,
            "project": {
                "id": 404,
                "name": "Exam00",
                "slug": "piscine-c-exam00",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-10T11:59:47.603Z",
            "marked": true,
            "retriable_at": "2018-08-10T11:59:47.717Z"
        },
        {
            "id": 973656,
            "occurrence": 0,
            "final_mark": 20,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2115639,
            "project": {
                "id": 156,
                "name": "Day 02",
                "slug": "piscine-c-day-02",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-10T03:03:19.588Z",
            "marked": true,
            "retriable_at": "2018-08-10T03:03:19.622Z"
        },
        {
            "id": 998370,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2142579,
            "project": {
                "id": 161,
                "name": "Day 07",
                "slug": "piscine-c-day-07",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-17T20:31:39.312Z",
            "marked": true,
            "retriable_at": "2018-08-17T20:31:39.365Z"
        },
        {
            "id": 1007721,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152635,
            "project": {
                "id": 200,
                "name": "16",
                "slug": "piscine-c-day-09-16",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:20.245Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:20.402Z"
        },
        {
            "id": 1582727,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2837444,
            "project": {
                "id": 750,
                "name": "Day 05",
                "slug": "piscine-swift-ios-day-05",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-09T11:13:20.055Z",
            "marked": true,
            "retriable_at": "2019-10-09T11:13:20.280Z"
        },
        {
            "id": 1588448,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2846443,
            "project": {
                "id": 755,
                "name": "Rush01",
                "slug": "piscine-swift-ios-rush01",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-14T16:01:08.507Z",
            "marked": true,
            "retriable_at": "2019-10-14T16:01:08.654Z"
        },
        {
            "id": 973674,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2115659,
            "project": {
                "id": 1049,
                "name": "UNIT Factory Harassment & Tolerance Policy",
                "slug": "unit-factory-harassment-tolerance-policy",
                "parent_id": null
            },
            "cursus_ids": [
                4,
                1
            ],
            "marked_at": "2018-08-12T10:13:56.169Z",
            "marked": true,
            "retriable_at": "2018-08-12T10:13:56.223Z"
        },
        {
            "id": 978029,
            "occurrence": 0,
            "final_mark": 60,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2120330,
            "project": {
                "id": 158,
                "name": "Day 04",
                "slug": "piscine-c-day-04",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-12T17:15:37.495Z",
            "marked": true,
            "retriable_at": "2018-08-12T17:15:37.664Z"
        },
        {
            "id": 1007710,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152625,
            "project": {
                "id": 190,
                "name": "06",
                "slug": "piscine-c-day-09-06",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:38.967Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:39.248Z"
        },
        {
            "id": 1001110,
            "occurrence": 0,
            "final_mark": 12,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2145799,
            "project": {
                "id": 167,
                "name": "Day 09",
                "slug": "piscine-c-day-09",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-18T12:48:24.457Z",
            "marked": true,
            "retriable_at": "2018-08-18T12:48:24.506Z"
        },
        {
            "id": 1001109,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2145798,
            "project": {
                "id": 162,
                "name": "Day 08",
                "slug": "piscine-c-day-08",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-19T16:24:05.510Z",
            "marked": true,
            "retriable_at": "2018-08-19T16:24:05.550Z"
        },
        {
            "id": 1007709,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152624,
            "project": {
                "id": 189,
                "name": "05",
                "slug": "piscine-c-day-09-05",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:40.995Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:41.221Z"
        },
        {
            "id": 1007720,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152634,
            "project": {
                "id": 199,
                "name": "15",
                "slug": "piscine-c-day-09-15",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:22.312Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:22.626Z"
        },
        {
            "id": 1007722,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152636,
            "project": {
                "id": 201,
                "name": "17",
                "slug": "piscine-c-day-09-17",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:17.963Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:18.463Z"
        },
        {
            "id": 1007612,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2156647,
            "project": {
                "id": 169,
                "name": "Rush 01",
                "slug": "piscine-c-rush-01",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-22T08:06:53.995Z",
            "marked": true,
            "retriable_at": "2018-08-22T08:06:54.049Z"
        },
        {
            "id": 1007101,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2151971,
            "project": {
                "id": 175,
                "name": "00",
                "slug": "piscine-c-day-09-00",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:50.162Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:50.319Z"
        },
        {
            "id": 1007712,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152626,
            "project": {
                "id": 191,
                "name": "07",
                "slug": "piscine-c-day-09-07",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:37.555Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:37.715Z"
        },
        {
            "id": 998369,
            "occurrence": 0,
            "final_mark": 20,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2142578,
            "project": {
                "id": 160,
                "name": "Day 06",
                "slug": "piscine-c-day-06",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-16T20:45:31.716Z",
            "marked": true,
            "retriable_at": "2018-08-16T20:45:31.759Z"
        },
        {
            "id": 1007717,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152631,
            "project": {
                "id": 196,
                "name": "12",
                "slug": "piscine-c-day-09-12",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:28.113Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:28.350Z"
        },
        {
            "id": 1007728,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152642,
            "project": {
                "id": 207,
                "name": "23",
                "slug": "piscine-c-day-09-23",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:05.842Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:06.039Z"
        },
        {
            "id": 1007723,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152637,
            "project": {
                "id": 202,
                "name": "18",
                "slug": "piscine-c-day-09-18",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:16.469Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:16.580Z"
        },
        {
            "id": 1007705,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152620,
            "project": {
                "id": 186,
                "name": "02",
                "slug": "piscine-c-day-09-02",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:46.250Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:46.547Z"
        },
        {
            "id": 1007727,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152641,
            "project": {
                "id": 206,
                "name": "22",
                "slug": "piscine-c-day-09-22",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:07.927Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:08.256Z"
        },
        {
            "id": 1007718,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152632,
            "project": {
                "id": 197,
                "name": "13",
                "slug": "piscine-c-day-09-13",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:25.804Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:26.282Z"
        },
        {
            "id": 1007706,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152621,
            "project": {
                "id": 187,
                "name": "03",
                "slug": "piscine-c-day-09-03",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:44.114Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:44.451Z"
        },
        {
            "id": 1007704,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152619,
            "project": {
                "id": 185,
                "name": "01",
                "slug": "piscine-c-day-09-01",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:48.087Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:48.464Z"
        },
        {
            "id": 1007715,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152629,
            "project": {
                "id": 194,
                "name": "10",
                "slug": "piscine-c-day-09-10",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:31.747Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:32.075Z"
        },
        {
            "id": 1007724,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152638,
            "project": {
                "id": 203,
                "name": "19",
                "slug": "piscine-c-day-09-19",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:14.599Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:14.939Z"
        },
        {
            "id": 984022,
            "occurrence": 0,
            "final_mark": 1,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2127533,
            "project": {
                "id": 159,
                "name": "Day 05",
                "slug": "piscine-c-day-05",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-15T03:57:03.694Z",
            "marked": true,
            "retriable_at": "2018-08-15T03:57:03.753Z"
        },
        {
            "id": 1002996,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2147910,
            "project": {
                "id": 405,
                "name": "Exam01",
                "slug": "piscine-c-exam01",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:51.699Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:51.960Z"
        },
        {
            "id": 1007716,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152630,
            "project": {
                "id": 195,
                "name": "11",
                "slug": "piscine-c-day-09-11",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:29.958Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:30.092Z"
        },
        {
            "id": 1007725,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152639,
            "project": {
                "id": 204,
                "name": "20",
                "slug": "piscine-c-day-09-20",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:12.378Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:12.717Z"
        },
        {
            "id": 1007726,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152640,
            "project": {
                "id": 205,
                "name": "21",
                "slug": "piscine-c-day-09-21",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:09.864Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:10.333Z"
        },
        {
            "id": 1007714,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152628,
            "project": {
                "id": 193,
                "name": "09",
                "slug": "piscine-c-day-09-09",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:33.880Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:34.012Z"
        },
        {
            "id": 1007713,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152627,
            "project": {
                "id": 192,
                "name": "08",
                "slug": "piscine-c-day-09-08",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:35.881Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:36.032Z"
        },
        {
            "id": 1007719,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152633,
            "project": {
                "id": 198,
                "name": "14",
                "slug": "piscine-c-day-09-14",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:24.289Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:24.551Z"
        },
        {
            "id": 1007708,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2152623,
            "project": {
                "id": 188,
                "name": "04",
                "slug": "piscine-c-day-09-04",
                "parent_id": 167
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T15:43:42.853Z",
            "marked": true,
            "retriable_at": "2018-08-31T15:43:43.045Z"
        },
        {
            "id": 1011707,
            "occurrence": 0,
            "final_mark": -42,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2157723,
            "project": {
                "id": 164,
                "name": "Day 11",
                "slug": "piscine-c-day-11",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-23T16:03:17.548Z",
            "marked": true,
            "retriable_at": "2018-08-23T16:03:17.579Z"
        },
        {
            "id": 982868,
            "occurrence": 0,
            "final_mark": 55,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2130911,
            "project": {
                "id": 168,
                "name": "Rush 00",
                "slug": "piscine-c-rush-00",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-15T22:02:13.863Z",
            "marked": true,
            "retriable_at": "2018-08-15T22:02:14.073Z"
        },
        {
            "id": 1011310,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2156969,
            "project": {
                "id": 163,
                "name": "Day 10",
                "slug": "piscine-c-day-10",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-22T03:16:52.680Z",
            "marked": true,
            "retriable_at": "2018-08-22T03:16:52.741Z"
        },
        {
            "id": 1011708,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2157724,
            "project": {
                "id": 165,
                "name": "Day 12",
                "slug": "piscine-c-day-12",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-24T18:58:47.340Z",
            "marked": true,
            "retriable_at": "2018-08-24T18:58:47.406Z"
        },
        {
            "id": 1208200,
            "occurrence": 2,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2477656,
            "project": {
                "id": 540,
                "name": "Fillit",
                "slug": "fillit",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-03-12T16:37:12.490Z",
            "marked": true,
            "retriable_at": "2019-03-14T16:37:12.688Z"
        },
        {
            "id": 1012503,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2158829,
            "project": {
                "id": 166,
                "name": "Day 13",
                "slug": "piscine-c-day-13",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-25T20:45:22.605Z",
            "marked": true,
            "retriable_at": "2018-08-25T20:45:22.646Z"
        },
        {
            "id": 1024513,
            "occurrence": 0,
            "final_mark": 36,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2173025,
            "project": {
                "id": 407,
                "name": "Exam Final",
                "slug": "piscine-c-exam-final",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-31T09:02:19.405Z",
            "marked": true,
            "retriable_at": "2018-08-31T09:02:19.602Z"
        },
        {
            "id": 1016621,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2163643,
            "project": {
                "id": 174,
                "name": "BSQ",
                "slug": "bsq",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-30T03:23:59.022Z",
            "marked": true,
            "retriable_at": "2018-08-30T03:23:59.058Z"
        },
        {
            "id": 1016783,
            "occurrence": 0,
            "final_mark": 27,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2163752,
            "project": {
                "id": 406,
                "name": "Exam02",
                "slug": "piscine-c-exam02",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-24T14:29:15.854Z",
            "marked": true,
            "retriable_at": "2018-08-24T14:29:16.010Z"
        },
        {
            "id": 1020655,
            "occurrence": 0,
            "final_mark": -42,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2168863,
            "project": {
                "id": 170,
                "name": "Rush 02",
                "slug": "piscine-c-rush-02",
                "parent_id": null
            },
            "cursus_ids": [
                4
            ],
            "marked_at": "2018-08-29T08:55:48.427Z",
            "marked": true,
            "retriable_at": "2018-08-29T08:55:48.507Z"
        },
        {
            "id": 1623086,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2886866,
            "project": {
                "id": 902,
                "name": "Curriculum Vitae",
                "slug": "curriculum-vitae",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2020-02-05T17:53:31.336Z",
            "marked": true,
            "retriable_at": "2020-02-06T17:53:31.712Z"
        },
        {
            "id": 1341188,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2533017,
            "project": {
                "id": 5,
                "name": "ft_printf",
                "slug": "ft_printf",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-04-26T20:17:18.238Z",
            "marked": true,
            "retriable_at": "2019-04-30T20:17:18.526Z"
        },
        {
            "id": 1623084,
            "occurrence": 0,
            "final_mark": null,
            "status": "in_progress",
            "validated?": null,
            "current_team_id": 2886863,
            "project": {
                "id": 536,
                "name": "Swifty Companion",
                "slug": "swifty-companion",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": null,
            "marked": false,
            "retriable_at": null
        },
        {
            "id": 1139253,
            "occurrence": 2,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2314038,
            "project": {
                "id": 756,
                "name": "Piscine Reloaded",
                "slug": "piscine-reloaded",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2018-10-26T16:18:42.399Z",
            "marked": true,
            "retriable_at": "2018-10-26T16:18:42.634Z"
        },
        {
            "id": 1392688,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2599782,
            "project": {
                "id": 26,
                "name": "Filler",
                "slug": "filler",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-07-03T14:35:46.984Z",
            "marked": true,
            "retriable_at": "2019-07-07T14:35:47.136Z"
        },
        {
            "id": 1397886,
            "occurrence": 0,
            "final_mark": 122,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2606447,
            "project": {
                "id": 29,
                "name": "Lem_in",
                "slug": "lem_in",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-07-24T20:36:08.060Z",
            "marked": true,
            "retriable_at": "2019-07-31T20:36:08.243Z"
        },
        {
            "id": 1139123,
            "occurrence": 1,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2300262,
            "project": {
                "id": 817,
                "name": "42 Commandements",
                "slug": "42-formation-pole-emploi-42-commandements",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2018-10-22T08:45:06.383Z",
            "marked": true,
            "retriable_at": "2018-10-22T08:45:06.462Z"
        },
        {
            "id": 1580861,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2835047,
            "project": {
                "id": 748,
                "name": "Day 04",
                "slug": "piscine-swift-ios-day-04",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-15T12:56:59.433Z",
            "marked": true,
            "retriable_at": "2019-10-15T12:56:59.586Z"
        },
        {
            "id": 1174096,
            "occurrence": 5,
            "final_mark": 85,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2751931,
            "project": {
                "id": 11,
                "name": "C Exam Alone In The Dark - Beginner",
                "slug": "c-exam-alone-in-the-dark-beginner",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-08-27T08:58:22.589Z",
            "marked": true,
            "retriable_at": "2019-08-27T08:58:22.773Z"
        },
        {
            "id": 1504871,
            "occurrence": 0,
            "final_mark": 125,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2734068,
            "project": {
                "id": 4,
                "name": "FdF",
                "slug": "fdf",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-10T18:05:31.442Z",
            "marked": true,
            "retriable_at": "2019-10-14T18:05:31.632Z"
        },
        {
            "id": 1572193,
            "occurrence": 0,
            "final_mark": 125,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2831783,
            "project": {
                "id": 22,
                "name": "Corewar",
                "slug": "corewar",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-09-29T21:35:31.775Z",
            "marked": true,
            "retriable_at": "2019-10-06T21:35:32.551Z"
        },
        {
            "id": 1579091,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2832963,
            "project": {
                "id": 744,
                "name": "Day 01",
                "slug": "piscine-swift-ios-day-01",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-05T09:44:59.276Z",
            "marked": true,
            "retriable_at": "2019-10-05T09:44:59.390Z"
        },
        {
            "id": 1579089,
            "occurrence": 0,
            "final_mark": 114,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2832961,
            "project": {
                "id": 742,
                "name": "Piscine Swift iOS",
                "slug": "piscine-swift-ios",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-15T12:57:03.068Z",
            "marked": true,
            "retriable_at": "2019-10-15T12:57:03.794Z"
        },
        {
            "id": 1152314,
            "occurrence": 2,
            "final_mark": 125,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2340734,
            "project": {
                "id": 1,
                "name": "Libft",
                "slug": "libft",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2018-11-20T18:43:07.439Z",
            "marked": true,
            "retriable_at": "2018-11-21T18:43:07.762Z"
        },
        {
            "id": 1174744,
            "occurrence": 0,
            "final_mark": 125,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2 341396,
            "project": {
                "id": 2,
                "name": "Get_Next_Line",
                "slug": "get_next_line",
                "parent_id": null
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-01-20T19:31:32.667Z",
            "marked": true,
            "retriable_at": "2019-01-21T19:31:33.089Z"
        },
        {
            "id": 1580860,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2835046,
            "project": {
                "id": 747,
                "name": "Day 03",
                "slug": "piscine-swift-ios-day-03",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-05T09:45:39.351Z",
            "marked": true,
            "retriable_at": "2019-10-05T09:45:39.469Z"
        },
        {
            "id": 1579090,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2832962,
            "project": {
                "id": 743,
                "name": "Day 00",
                "slug": "piscine-swift-ios-day-00",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-03T13:01:47.798Z",
            "marked": true,
            "retriable_at": "2019-10-03T13:01:47.930Z"
        },
        {
            "id": 1580859,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2835045,
            "project": {
                "id": 745,
                "name": "Day 02",
                "slug": "piscine-swift-ios-day-02",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-05T10:28:11.098Z",
            "marked": true,
            "retriable_at": "2019-10-05T10:28:11.246Z"
        },
        {
            "id": 1585526,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2840749,
            "project": {
                "id": 752,
                "name": "Day 07",
                "slug": "piscine-swift-ios-day-07",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-11T14:14:26.207Z",
            "marked": true,
            "retriable_at": "2019-10-11T14:14:26.349Z"
        },
        {
            "id": 1580862,
            "occurrence": 0,
            "final_mark": 0,
            "status": "finished",
            "validated?": false,
            "current_team_id": 2837997,
            "project": {
                "id": 749,
                "name": "Rush00",
                "slug": "piscine-swift-ios-rush00",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-10T19:37:27.828Z",
            "marked": true,
            "retriable_at": "2019-10-10T19:37:27.987Z"
        },
        {
            "id": 1585523,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2840746,
            "project": {
                "id": 751,
                "name": "Day 06",
                "slug": "piscine-swift-ios-day-06",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-10T11:03:24.153Z",
            "marked": true,
            "retriable_at": "2019-10-10T11:03:24.303Z"
        },
        {
            "id": 1585527,
            "occurrence": 0,
            "final_mark": 100,
            "status": "finished",
            "validated?": true,
            "current_team_id": 2840750,
            "project": {
                "id": 753,
                "name": "Day 08",
                "slug": "piscine-swift-ios-day-08",
                "parent_id": 742
            },
            "cursus_ids": [
                1
            ],
            "marked_at": "2019-10-15T12:56:15.096Z",
            "marked": true,
            "retriable_at": "2019-10-15T12:56:15.318Z"
        }
    ],
    "languages_users": [
        {
            "id": 204167,
            "language_id": 2,
            "user_id": 41821,
            "position": 1,
            "created_at": "2019-09-30T11:54:04.020Z"
        },
        {
            "id": 204168,
            "language_id": 5,
            "user_id": 41821,
            "position": 2,
            "created_at": "2019-09-30T11:54:04.037Z"
        },
        {
            "id": 204169,
            "language_id": 6,
            "user_id": 41821,
            "position": 3,
            "created_at": "2019-09-30T11:54:04.055Z"
        }
    ],
    "achievements": [
        {
            "id": 41,
            "name": "All work and no play makes Jack a dull boy",
            "description": "Etre logué 90h sur une semaine. ",
            "tier": "easy",
            "kind": "scolarity",
            "visible": true,
            "image": "/uploads/achievement/image/41/SCO001.svg",
            "nbr_of_success": null,
            "users_url": "https://api.intra.42.fr/v2/achievements/41/users"
        },
        {
            "id": 17,
            "name": "Bonus Hunter",
            "description": "Valider 1 projet avec la note maximum.",
            "tier": "easy",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/17/PRO005.svg",
            "nbr_of_success": 1,
            "users_url": "https://api.intra.42.fr/v2/achievements/17/users"
        },
        {
            "id": 18,
            "name": "Bonus Hunter",
            "description": "Valider 3 projets avec la note maximum.",
            "tier": "medium",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/18/PRO005.svg",
            "nbr_of_success": 3,
            "users_url": "https://api.intra.42.fr/v2/achievements/18/users"
        },
        {
            "id": 4,
            "name": "Code Explorer",
            "description": "Valider son premier projet.",
            "tier": "none",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/4/PRO002.svg",
            "nbr_of_success": 1,
            "users_url": "https://api.intra.42.fr/v2/achievements/4/users"
        },
        {
            "id": 5,
            "name": "Code Explorer",
            "description": "Valider 3 projets.",
            "tier": "none",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/5/PRO002.svg",
            "nbr_of_success": 3,
            "users_url": "https://api.intra.42.fr/v2/achievements/5/users"
        },
        {
            "id": 6,
            "name": "Code Explorer",
            "description": "Valider 10 projets.",
            "tier": "none",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/6/PRO002.svg",
            "nbr_of_success": 10,
            "users_url": "https://api.intra.42.fr/v2/achievements/6/users"
        },
        {
            "id": 44,
            "name": "Curious wanderer",
            "description": "S'être logué une fois dans chaque cluster.",
            "tier": "none",
            "kind": "scolarity",
            "visible": false,
            "image": "/uploads/achievement/image/44/SCO002.svg",
            "nbr_of_success": null,
            "users_url": "https://api.intra.42.fr/v2/achievements/44/users"
        },
        {
            "id": 46,
            "name": "Film buff",
            "description": "Regarder 1 video sur l'e-learning.",
            "tier": "none",
            "kind": "pedagogy",
            "visible": false,
            "image": "/uploads/achievement/image/46/PED005.svg",
            "nbr_of_success": 1,
            "users_url": "https://api.intra.42.fr/v2/achievements/46/users"
        },
        {
            "id": 47,
            "name": "Film buff",
            "description": "Regarder 3 videos sur l'e-learning.",
            "tier": "none",
            "kind": "pedagogy",
            "visible": false,
            "image": "/uploads/achievement/image/47/PED005.svg",
            "nbr_of_success": 3,
            "users_url": "https://api.intra.42.fr/v2/achievements/47/users"
        },
        {
            "id": 48,
            "name": "Film buff",
            "description": "Regarder 10 videos sur l'e-learning.",
            "tier": "none",
            "kind": "pedagogy",
            "visible": false,
            "image": "/uploads/achievement/image/48/PED005.svg",
            "nbr_of_success": 10,
            "users_url": "https://api.intra.42.fr/v2/achievements/48/users"
        },
        {
            "id": 49,
            "name": "Film buff",
            "description": "Regarder 21 videos sur l'e-learning.",
            "tier": "none",
            "kind": "pedagogy",
            "visible": false,
            "image": "/uploads/achievement/image/49/PED005.svg",
            "nbr_of_success": 21,
            "users_url": "https://api.intra.42.fr/v2/achievements/49/users"
        },
        {
            "id": 50,
            "name": "Film buff",
            "description": "Regarder 42 videos sur l'e-learning.",
            "tier": "none",
            "kind": "pedagogy",
            "visible": true,
            "image": "/uploads/achievement/image/50/PED005.svg",
            "nbr_of_success": 42,
            "users_url": "https://api.intra.42.fr/v2/achievements/50/users"
        },
        {
            "id": 45,
            "name": "Home is where the code is",
            "description": "S'être logué dans le même cluster un mois de suite.",
            "tier": "none",
            "kind": "scolarity",
            "visible": true,
            "image": "/uploads/achievement/image/45/SCO002.svg",
            "nbr_of_success": null,
            "users_url": "https://api.intra.42.fr/v2/achievements/45/users"
        },
        {
            "id": 82,
            "name": "I have no idea what I'm doing",
            "description": "Faire une soutenance sans avoir validé le projet.",
            "tier": "none",
            "kind": "pedagogy",
            "visible": true,
            "image": "/uploads/achievement/image/82/PED011.svg",
            "nbr_of_success": null,
            "users_url": "https://api.intra.42.fr/v2/achievements/82/users"
        },
        {
            "id": 84,
            "name": "I'm reliable !",
            "description": "Participer à 21 soutenances d'affilée sans en manquer aucune.",
            "tier": "easy",
            "kind": "pedagogy",
            "visible": true,
            "image": "/uploads/achievement/image/84/PED009.svg",
            "nbr_of_success": 21,
            "users_url": "https://api.intra.42.fr/v2/achievements/84/users"
        },
        {
            "id": 25,
            "name": "Rigorous Basterd",
            "description": "Valider 3 projets d'affilée (journées de piscines comprises).",
            "tier": "none",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/25/PRO010.svg",
            "nbr_of_success": 3,
            "users_url": "https://api.intra.42.fr/v2/achievements/25/users"
        },
        {
            "id": 26,
            "name": "Rigorous Basterd",
            "description": "Valider 10 projets d'affilée (journées de piscines comprises).",
            "tier": "easy",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/26/PRO010.svg",
            "nbr_of_success": 10,
            "users_url": "https://api.intra.42.fr/v2/achievements/26/users"
        },
        {
            "id": 27,
            "name": "Rigorous Basterd",
            "description": "Valider 21 projets d'affilée (journées de piscines comprises).",
            "tier": "medium",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/27/PRO010.svg",
            "nbr_of_success": 21,
            "users_url": "https://api.intra.42.fr/v2/achievements/27/users"
        },
        {
            "id": 1,
            "name": "Welcome, Cadet !",
            "description": "Tu as réussi ta piscine C. Bienvenue à 42 !",
            "tier": "none",
            "kind": "project",
            "visible": true,
            "image": "/uploads/achievement/image/1/PRO001.svg",
            "nbr_of_success": null,
            "users_url": "https://api.intra.42.fr/v2/achievements/1/users"
        }
    ],
    "titles": [],
    "titles_users": [],
    "partnerships": [],
    "patroned": [
        {
            "id": 1446,
            "user_id": 41821,
            "godfather_id": 33801,
            "ongoing": true,
            "created_at": "2018-11-05T16:55:33.220Z",
            "updated_at": "2019-07-06T13:53:02.534Z"
        }
    ],
    "patroning": [],
    "expertises_users": [],
    "campus": [
        {
            "id": 8,
            "name": "Kyiv",
            "time_zone": "Europe/Kiev",
            "language": {
                "id": 5,
                "name": "Ukrainian",
                "identifier": "uk",
                "created_at": "2016-08-21T11:42:57.272Z",
                "updated_at": "2019-10-11T11:09:06.137Z"
            },
            "users_count": 2636,
            "vogsphere_id": 3,
            "country": "Ukraine",
            "address": "Dorohozhytska St, 3",
            "zip": "04119",
            "city": "Kyiv",
            "website": "https://unit.ua/",
            "facebook": "https://www.facebook.com/unit.factory/",
            "twitter": ""
        }
    ],
    "campus_users": [
        {
            "id": 32255,
            "user_id": 41821,
            "campus_id": 8,
            "is_primary": true
        }
    ]
}
 */
