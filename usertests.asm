
_usertests:     file format elf32-i386


Disassembly of section .text:

00001000 <opentest>:
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
    1006:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    100b:	c7 44 24 04 06 54 00 	movl   $0x5406,0x4(%esp)
    1012:	00 
    1013:	89 04 24             	mov    %eax,(%esp)
    1016:	e8 9a 3d 00 00       	call   4db5 <printf>
    101b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1022:	00 
    1023:	c7 04 24 f0 53 00 00 	movl   $0x53f0,(%esp)
    102a:	e8 2d 3c 00 00       	call   4c5c <open>
    102f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1036:	79 1a                	jns    1052 <opentest+0x52>
    1038:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    103d:	c7 44 24 04 11 54 00 	movl   $0x5411,0x4(%esp)
    1044:	00 
    1045:	89 04 24             	mov    %eax,(%esp)
    1048:	e8 68 3d 00 00       	call   4db5 <printf>
    104d:	e8 ca 3b 00 00       	call   4c1c <exit>
    1052:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1055:	89 04 24             	mov    %eax,(%esp)
    1058:	e8 e7 3b 00 00       	call   4c44 <close>
    105d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1064:	00 
    1065:	c7 04 24 24 54 00 00 	movl   $0x5424,(%esp)
    106c:	e8 eb 3b 00 00       	call   4c5c <open>
    1071:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1078:	78 1a                	js     1094 <opentest+0x94>
    107a:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    107f:	c7 44 24 04 31 54 00 	movl   $0x5431,0x4(%esp)
    1086:	00 
    1087:	89 04 24             	mov    %eax,(%esp)
    108a:	e8 26 3d 00 00       	call   4db5 <printf>
    108f:	e8 88 3b 00 00       	call   4c1c <exit>
    1094:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1099:	c7 44 24 04 4f 54 00 	movl   $0x544f,0x4(%esp)
    10a0:	00 
    10a1:	89 04 24             	mov    %eax,(%esp)
    10a4:	e8 0c 3d 00 00       	call   4db5 <printf>
    10a9:	c9                   	leave  
    10aa:	c3                   	ret    

000010ab <writetest>:
    10ab:	55                   	push   %ebp
    10ac:	89 e5                	mov    %esp,%ebp
    10ae:	83 ec 28             	sub    $0x28,%esp
    10b1:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    10b6:	c7 44 24 04 5d 54 00 	movl   $0x545d,0x4(%esp)
    10bd:	00 
    10be:	89 04 24             	mov    %eax,(%esp)
    10c1:	e8 ef 3c 00 00       	call   4db5 <printf>
    10c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10cd:	00 
    10ce:	c7 04 24 6e 54 00 00 	movl   $0x546e,(%esp)
    10d5:	e8 82 3b 00 00       	call   4c5c <open>
    10da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    10dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10e1:	78 21                	js     1104 <writetest+0x59>
    10e3:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    10e8:	c7 44 24 04 74 54 00 	movl   $0x5474,0x4(%esp)
    10ef:	00 
    10f0:	89 04 24             	mov    %eax,(%esp)
    10f3:	e8 bd 3c 00 00       	call   4db5 <printf>
    10f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10ff:	e9 a0 00 00 00       	jmp    11a4 <writetest+0xf9>
    1104:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1109:	c7 44 24 04 8f 54 00 	movl   $0x548f,0x4(%esp)
    1110:	00 
    1111:	89 04 24             	mov    %eax,(%esp)
    1114:	e8 9c 3c 00 00       	call   4db5 <printf>
    1119:	e8 fe 3a 00 00       	call   4c1c <exit>
    111e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1125:	00 
    1126:	c7 44 24 04 ab 54 00 	movl   $0x54ab,0x4(%esp)
    112d:	00 
    112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1131:	89 04 24             	mov    %eax,(%esp)
    1134:	e8 03 3b 00 00       	call   4c3c <write>
    1139:	83 f8 0a             	cmp    $0xa,%eax
    113c:	74 21                	je     115f <writetest+0xb4>
    113e:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1143:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1146:	89 54 24 08          	mov    %edx,0x8(%esp)
    114a:	c7 44 24 04 b8 54 00 	movl   $0x54b8,0x4(%esp)
    1151:	00 
    1152:	89 04 24             	mov    %eax,(%esp)
    1155:	e8 5b 3c 00 00       	call   4db5 <printf>
    115a:	e8 bd 3a 00 00       	call   4c1c <exit>
    115f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1166:	00 
    1167:	c7 44 24 04 dc 54 00 	movl   $0x54dc,0x4(%esp)
    116e:	00 
    116f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1172:	89 04 24             	mov    %eax,(%esp)
    1175:	e8 c2 3a 00 00       	call   4c3c <write>
    117a:	83 f8 0a             	cmp    $0xa,%eax
    117d:	74 21                	je     11a0 <writetest+0xf5>
    117f:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1184:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1187:	89 54 24 08          	mov    %edx,0x8(%esp)
    118b:	c7 44 24 04 e8 54 00 	movl   $0x54e8,0x4(%esp)
    1192:	00 
    1193:	89 04 24             	mov    %eax,(%esp)
    1196:	e8 1a 3c 00 00       	call   4db5 <printf>
    119b:	e8 7c 3a 00 00       	call   4c1c <exit>
    11a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11a4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    11a8:	0f 8e 70 ff ff ff    	jle    111e <writetest+0x73>
    11ae:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    11b3:	c7 44 24 04 0c 55 00 	movl   $0x550c,0x4(%esp)
    11ba:	00 
    11bb:	89 04 24             	mov    %eax,(%esp)
    11be:	e8 f2 3b 00 00       	call   4db5 <printf>
    11c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11c6:	89 04 24             	mov    %eax,(%esp)
    11c9:	e8 76 3a 00 00       	call   4c44 <close>
    11ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11d5:	00 
    11d6:	c7 04 24 6e 54 00 00 	movl   $0x546e,(%esp)
    11dd:	e8 7a 3a 00 00       	call   4c5c <open>
    11e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    11e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11e9:	78 3e                	js     1229 <writetest+0x17e>
    11eb:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    11f0:	c7 44 24 04 17 55 00 	movl   $0x5517,0x4(%esp)
    11f7:	00 
    11f8:	89 04 24             	mov    %eax,(%esp)
    11fb:	e8 b5 3b 00 00       	call   4db5 <printf>
    1200:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    1207:	00 
    1208:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    120f:	00 
    1210:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1213:	89 04 24             	mov    %eax,(%esp)
    1216:	e8 19 3a 00 00       	call   4c34 <read>
    121b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    121e:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
    1225:	74 1c                	je     1243 <writetest+0x198>
    1227:	eb 4c                	jmp    1275 <writetest+0x1ca>
    1229:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    122e:	c7 44 24 04 30 55 00 	movl   $0x5530,0x4(%esp)
    1235:	00 
    1236:	89 04 24             	mov    %eax,(%esp)
    1239:	e8 77 3b 00 00       	call   4db5 <printf>
    123e:	e8 d9 39 00 00       	call   4c1c <exit>
    1243:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1248:	c7 44 24 04 4b 55 00 	movl   $0x554b,0x4(%esp)
    124f:	00 
    1250:	89 04 24             	mov    %eax,(%esp)
    1253:	e8 5d 3b 00 00       	call   4db5 <printf>
    1258:	8b 45 f0             	mov    -0x10(%ebp),%eax
    125b:	89 04 24             	mov    %eax,(%esp)
    125e:	e8 e1 39 00 00       	call   4c44 <close>
    1263:	c7 04 24 6e 54 00 00 	movl   $0x546e,(%esp)
    126a:	e8 fd 39 00 00       	call   4c6c <unlink>
    126f:	85 c0                	test   %eax,%eax
    1271:	78 1c                	js     128f <writetest+0x1e4>
    1273:	eb 34                	jmp    12a9 <writetest+0x1fe>
    1275:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    127a:	c7 44 24 04 5e 55 00 	movl   $0x555e,0x4(%esp)
    1281:	00 
    1282:	89 04 24             	mov    %eax,(%esp)
    1285:	e8 2b 3b 00 00       	call   4db5 <printf>
    128a:	e8 8d 39 00 00       	call   4c1c <exit>
    128f:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1294:	c7 44 24 04 6b 55 00 	movl   $0x556b,0x4(%esp)
    129b:	00 
    129c:	89 04 24             	mov    %eax,(%esp)
    129f:	e8 11 3b 00 00       	call   4db5 <printf>
    12a4:	e8 73 39 00 00       	call   4c1c <exit>
    12a9:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    12ae:	c7 44 24 04 80 55 00 	movl   $0x5580,0x4(%esp)
    12b5:	00 
    12b6:	89 04 24             	mov    %eax,(%esp)
    12b9:	e8 f7 3a 00 00       	call   4db5 <printf>
    12be:	c9                   	leave  
    12bf:	c3                   	ret    

000012c0 <writetest1>:
    12c0:	55                   	push   %ebp
    12c1:	89 e5                	mov    %esp,%ebp
    12c3:	83 ec 28             	sub    $0x28,%esp
    12c6:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    12cb:	c7 44 24 04 94 55 00 	movl   $0x5594,0x4(%esp)
    12d2:	00 
    12d3:	89 04 24             	mov    %eax,(%esp)
    12d6:	e8 da 3a 00 00       	call   4db5 <printf>
    12db:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    12e2:	00 
    12e3:	c7 04 24 a4 55 00 00 	movl   $0x55a4,(%esp)
    12ea:	e8 6d 39 00 00       	call   4c5c <open>
    12ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12f6:	79 1a                	jns    1312 <writetest1+0x52>
    12f8:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    12fd:	c7 44 24 04 a8 55 00 	movl   $0x55a8,0x4(%esp)
    1304:	00 
    1305:	89 04 24             	mov    %eax,(%esp)
    1308:	e8 a8 3a 00 00       	call   4db5 <printf>
    130d:	e8 0a 39 00 00       	call   4c1c <exit>
    1312:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1319:	eb 51                	jmp    136c <writetest1+0xac>
    131b:	b8 e0 92 00 00       	mov    $0x92e0,%eax
    1320:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1323:	89 10                	mov    %edx,(%eax)
    1325:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    132c:	00 
    132d:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    1334:	00 
    1335:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1338:	89 04 24             	mov    %eax,(%esp)
    133b:	e8 fc 38 00 00       	call   4c3c <write>
    1340:	3d 00 02 00 00       	cmp    $0x200,%eax
    1345:	74 21                	je     1368 <writetest1+0xa8>
    1347:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    134c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    134f:	89 54 24 08          	mov    %edx,0x8(%esp)
    1353:	c7 44 24 04 c2 55 00 	movl   $0x55c2,0x4(%esp)
    135a:	00 
    135b:	89 04 24             	mov    %eax,(%esp)
    135e:	e8 52 3a 00 00       	call   4db5 <printf>
    1363:	e8 b4 38 00 00       	call   4c1c <exit>
    1368:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    136c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    136f:	3d 8b 00 00 00       	cmp    $0x8b,%eax
    1374:	76 a5                	jbe    131b <writetest1+0x5b>
    1376:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1379:	89 04 24             	mov    %eax,(%esp)
    137c:	e8 c3 38 00 00       	call   4c44 <close>
    1381:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1388:	00 
    1389:	c7 04 24 a4 55 00 00 	movl   $0x55a4,(%esp)
    1390:	e8 c7 38 00 00       	call   4c5c <open>
    1395:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    139c:	79 1a                	jns    13b8 <writetest1+0xf8>
    139e:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    13a3:	c7 44 24 04 e0 55 00 	movl   $0x55e0,0x4(%esp)
    13aa:	00 
    13ab:	89 04 24             	mov    %eax,(%esp)
    13ae:	e8 02 3a 00 00       	call   4db5 <printf>
    13b3:	e8 64 38 00 00       	call   4c1c <exit>
    13b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13bf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    13c6:	00 
    13c7:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    13ce:	00 
    13cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13d2:	89 04 24             	mov    %eax,(%esp)
    13d5:	e8 5a 38 00 00       	call   4c34 <read>
    13da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13e1:	75 2e                	jne    1411 <writetest1+0x151>
    13e3:	81 7d f4 8b 00 00 00 	cmpl   $0x8b,-0xc(%ebp)
    13ea:	0f 85 8c 00 00 00    	jne    147c <writetest1+0x1bc>
    13f0:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    13f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13f8:	89 54 24 08          	mov    %edx,0x8(%esp)
    13fc:	c7 44 24 04 f9 55 00 	movl   $0x55f9,0x4(%esp)
    1403:	00 
    1404:	89 04 24             	mov    %eax,(%esp)
    1407:	e8 a9 39 00 00       	call   4db5 <printf>
    140c:	e8 0b 38 00 00       	call   4c1c <exit>
    1411:	81 7d ec 00 02 00 00 	cmpl   $0x200,-0x14(%ebp)
    1418:	74 21                	je     143b <writetest1+0x17b>
    141a:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    141f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1422:	89 54 24 08          	mov    %edx,0x8(%esp)
    1426:	c7 44 24 04 16 56 00 	movl   $0x5616,0x4(%esp)
    142d:	00 
    142e:	89 04 24             	mov    %eax,(%esp)
    1431:	e8 7f 39 00 00       	call   4db5 <printf>
    1436:	e8 e1 37 00 00       	call   4c1c <exit>
    143b:	b8 e0 92 00 00       	mov    $0x92e0,%eax
    1440:	8b 00                	mov    (%eax),%eax
    1442:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1445:	74 2c                	je     1473 <writetest1+0x1b3>
    1447:	b8 e0 92 00 00       	mov    $0x92e0,%eax
    144c:	8b 10                	mov    (%eax),%edx
    144e:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1453:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1457:	8b 55 f4             	mov    -0xc(%ebp),%edx
    145a:	89 54 24 08          	mov    %edx,0x8(%esp)
    145e:	c7 44 24 04 28 56 00 	movl   $0x5628,0x4(%esp)
    1465:	00 
    1466:	89 04 24             	mov    %eax,(%esp)
    1469:	e8 47 39 00 00       	call   4db5 <printf>
    146e:	e8 a9 37 00 00       	call   4c1c <exit>
    1473:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1477:	e9 43 ff ff ff       	jmp    13bf <writetest1+0xff>
    147c:	90                   	nop
    147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1480:	89 04 24             	mov    %eax,(%esp)
    1483:	e8 bc 37 00 00       	call   4c44 <close>
    1488:	c7 04 24 a4 55 00 00 	movl   $0x55a4,(%esp)
    148f:	e8 d8 37 00 00       	call   4c6c <unlink>
    1494:	85 c0                	test   %eax,%eax
    1496:	79 1a                	jns    14b2 <writetest1+0x1f2>
    1498:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    149d:	c7 44 24 04 48 56 00 	movl   $0x5648,0x4(%esp)
    14a4:	00 
    14a5:	89 04 24             	mov    %eax,(%esp)
    14a8:	e8 08 39 00 00       	call   4db5 <printf>
    14ad:	e8 6a 37 00 00       	call   4c1c <exit>
    14b2:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    14b7:	c7 44 24 04 5b 56 00 	movl   $0x565b,0x4(%esp)
    14be:	00 
    14bf:	89 04 24             	mov    %eax,(%esp)
    14c2:	e8 ee 38 00 00       	call   4db5 <printf>
    14c7:	c9                   	leave  
    14c8:	c3                   	ret    

000014c9 <createtest>:
    14c9:	55                   	push   %ebp
    14ca:	89 e5                	mov    %esp,%ebp
    14cc:	83 ec 28             	sub    $0x28,%esp
    14cf:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    14d4:	c7 44 24 04 6c 56 00 	movl   $0x566c,0x4(%esp)
    14db:	00 
    14dc:	89 04 24             	mov    %eax,(%esp)
    14df:	e8 d1 38 00 00       	call   4db5 <printf>
    14e4:	c6 05 e0 b2 00 00 61 	movb   $0x61,0xb2e0
    14eb:	c6 05 e2 b2 00 00 00 	movb   $0x0,0xb2e2
    14f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14f9:	eb 31                	jmp    152c <createtest+0x63>
    14fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14fe:	83 c0 30             	add    $0x30,%eax
    1501:	a2 e1 b2 00 00       	mov    %al,0xb2e1
    1506:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    150d:	00 
    150e:	c7 04 24 e0 b2 00 00 	movl   $0xb2e0,(%esp)
    1515:	e8 42 37 00 00       	call   4c5c <open>
    151a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1520:	89 04 24             	mov    %eax,(%esp)
    1523:	e8 1c 37 00 00       	call   4c44 <close>
    1528:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    152c:	83 7d f0 33          	cmpl   $0x33,-0x10(%ebp)
    1530:	7e c9                	jle    14fb <createtest+0x32>
    1532:	c6 05 e0 b2 00 00 61 	movb   $0x61,0xb2e0
    1539:	c6 05 e2 b2 00 00 00 	movb   $0x0,0xb2e2
    1540:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1547:	eb 1b                	jmp    1564 <createtest+0x9b>
    1549:	8b 45 f0             	mov    -0x10(%ebp),%eax
    154c:	83 c0 30             	add    $0x30,%eax
    154f:	a2 e1 b2 00 00       	mov    %al,0xb2e1
    1554:	c7 04 24 e0 b2 00 00 	movl   $0xb2e0,(%esp)
    155b:	e8 0c 37 00 00       	call   4c6c <unlink>
    1560:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1564:	83 7d f0 33          	cmpl   $0x33,-0x10(%ebp)
    1568:	7e df                	jle    1549 <createtest+0x80>
    156a:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    156f:	c7 44 24 04 94 56 00 	movl   $0x5694,0x4(%esp)
    1576:	00 
    1577:	89 04 24             	mov    %eax,(%esp)
    157a:	e8 36 38 00 00       	call   4db5 <printf>
    157f:	c9                   	leave  
    1580:	c3                   	ret    

00001581 <dirtest>:
    1581:	55                   	push   %ebp
    1582:	89 e5                	mov    %esp,%ebp
    1584:	83 ec 18             	sub    $0x18,%esp
    1587:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    158c:	c7 44 24 04 ba 56 00 	movl   $0x56ba,0x4(%esp)
    1593:	00 
    1594:	89 04 24             	mov    %eax,(%esp)
    1597:	e8 19 38 00 00       	call   4db5 <printf>
    159c:	c7 04 24 c6 56 00 00 	movl   $0x56c6,(%esp)
    15a3:	e8 dc 36 00 00       	call   4c84 <mkdir>
    15a8:	85 c0                	test   %eax,%eax
    15aa:	79 1a                	jns    15c6 <dirtest+0x45>
    15ac:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    15b1:	c7 44 24 04 cb 56 00 	movl   $0x56cb,0x4(%esp)
    15b8:	00 
    15b9:	89 04 24             	mov    %eax,(%esp)
    15bc:	e8 f4 37 00 00       	call   4db5 <printf>
    15c1:	e8 56 36 00 00       	call   4c1c <exit>
    15c6:	c7 04 24 c6 56 00 00 	movl   $0x56c6,(%esp)
    15cd:	e8 ba 36 00 00       	call   4c8c <chdir>
    15d2:	85 c0                	test   %eax,%eax
    15d4:	79 1a                	jns    15f0 <dirtest+0x6f>
    15d6:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    15db:	c7 44 24 04 d9 56 00 	movl   $0x56d9,0x4(%esp)
    15e2:	00 
    15e3:	89 04 24             	mov    %eax,(%esp)
    15e6:	e8 ca 37 00 00       	call   4db5 <printf>
    15eb:	e8 2c 36 00 00       	call   4c1c <exit>
    15f0:	c7 04 24 ec 56 00 00 	movl   $0x56ec,(%esp)
    15f7:	e8 90 36 00 00       	call   4c8c <chdir>
    15fc:	85 c0                	test   %eax,%eax
    15fe:	79 1a                	jns    161a <dirtest+0x99>
    1600:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1605:	c7 44 24 04 ef 56 00 	movl   $0x56ef,0x4(%esp)
    160c:	00 
    160d:	89 04 24             	mov    %eax,(%esp)
    1610:	e8 a0 37 00 00       	call   4db5 <printf>
    1615:	e8 02 36 00 00       	call   4c1c <exit>
    161a:	c7 04 24 c6 56 00 00 	movl   $0x56c6,(%esp)
    1621:	e8 46 36 00 00       	call   4c6c <unlink>
    1626:	85 c0                	test   %eax,%eax
    1628:	79 1a                	jns    1644 <dirtest+0xc3>
    162a:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    162f:	c7 44 24 04 00 57 00 	movl   $0x5700,0x4(%esp)
    1636:	00 
    1637:	89 04 24             	mov    %eax,(%esp)
    163a:	e8 76 37 00 00       	call   4db5 <printf>
    163f:	e8 d8 35 00 00       	call   4c1c <exit>
    1644:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1649:	c7 44 24 04 ba 56 00 	movl   $0x56ba,0x4(%esp)
    1650:	00 
    1651:	89 04 24             	mov    %eax,(%esp)
    1654:	e8 5c 37 00 00       	call   4db5 <printf>
    1659:	c9                   	leave  
    165a:	c3                   	ret    

0000165b <exectest>:
    165b:	55                   	push   %ebp
    165c:	89 e5                	mov    %esp,%ebp
    165e:	83 ec 18             	sub    $0x18,%esp
    1661:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1666:	c7 44 24 04 14 57 00 	movl   $0x5714,0x4(%esp)
    166d:	00 
    166e:	89 04 24             	mov    %eax,(%esp)
    1671:	e8 3f 37 00 00       	call   4db5 <printf>
    1676:	c7 44 24 04 e8 6a 00 	movl   $0x6ae8,0x4(%esp)
    167d:	00 
    167e:	c7 04 24 f0 53 00 00 	movl   $0x53f0,(%esp)
    1685:	e8 ca 35 00 00       	call   4c54 <exec>
    168a:	85 c0                	test   %eax,%eax
    168c:	79 1a                	jns    16a8 <exectest+0x4d>
    168e:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    1693:	c7 44 24 04 1f 57 00 	movl   $0x571f,0x4(%esp)
    169a:	00 
    169b:	89 04 24             	mov    %eax,(%esp)
    169e:	e8 12 37 00 00       	call   4db5 <printf>
    16a3:	e8 74 35 00 00       	call   4c1c <exit>
    16a8:	c9                   	leave  
    16a9:	c3                   	ret    

000016aa <pipe1>:
    16aa:	55                   	push   %ebp
    16ab:	89 e5                	mov    %esp,%ebp
    16ad:	83 ec 38             	sub    $0x38,%esp
    16b0:	8d 45 d8             	lea    -0x28(%ebp),%eax
    16b3:	89 04 24             	mov    %eax,(%esp)
    16b6:	e8 71 35 00 00       	call   4c2c <pipe>
    16bb:	85 c0                	test   %eax,%eax
    16bd:	74 19                	je     16d8 <pipe1+0x2e>
    16bf:	c7 44 24 04 31 57 00 	movl   $0x5731,0x4(%esp)
    16c6:	00 
    16c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16ce:	e8 e2 36 00 00       	call   4db5 <printf>
    16d3:	e8 44 35 00 00       	call   4c1c <exit>
    16d8:	e8 37 35 00 00       	call   4c14 <fork>
    16dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    16e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    16e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    16eb:	0f 85 84 00 00 00    	jne    1775 <pipe1+0xcb>
    16f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
    16f4:	89 04 24             	mov    %eax,(%esp)
    16f7:	e8 48 35 00 00       	call   4c44 <close>
    16fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1703:	eb 65                	jmp    176a <pipe1+0xc0>
    1705:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    170c:	eb 14                	jmp    1722 <pipe1+0x78>
    170e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1714:	88 90 e0 92 00 00    	mov    %dl,0x92e0(%eax)
    171a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    171e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1722:	81 7d e8 08 04 00 00 	cmpl   $0x408,-0x18(%ebp)
    1729:	7e e3                	jle    170e <pipe1+0x64>
    172b:	8b 45 dc             	mov    -0x24(%ebp),%eax
    172e:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    1735:	00 
    1736:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    173d:	00 
    173e:	89 04 24             	mov    %eax,(%esp)
    1741:	e8 f6 34 00 00       	call   4c3c <write>
    1746:	3d 09 04 00 00       	cmp    $0x409,%eax
    174b:	74 19                	je     1766 <pipe1+0xbc>
    174d:	c7 44 24 04 40 57 00 	movl   $0x5740,0x4(%esp)
    1754:	00 
    1755:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    175c:	e8 54 36 00 00       	call   4db5 <printf>
    1761:	e8 b6 34 00 00       	call   4c1c <exit>
    1766:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    176a:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
    176e:	7e 95                	jle    1705 <pipe1+0x5b>
    1770:	e8 a7 34 00 00       	call   4c1c <exit>
    1775:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1779:	0f 8e fb 00 00 00    	jle    187a <pipe1+0x1d0>
    177f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1782:	89 04 24             	mov    %eax,(%esp)
    1785:	e8 ba 34 00 00       	call   4c44 <close>
    178a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1791:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    1798:	eb 6a                	jmp    1804 <pipe1+0x15a>
    179a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    17a1:	eb 3f                	jmp    17e2 <pipe1+0x138>
    17a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17a6:	0f b6 80 e0 92 00 00 	movzbl 0x92e0(%eax),%eax
    17ad:	0f be c0             	movsbl %al,%eax
    17b0:	33 45 e4             	xor    -0x1c(%ebp),%eax
    17b3:	25 ff 00 00 00       	and    $0xff,%eax
    17b8:	85 c0                	test   %eax,%eax
    17ba:	0f 95 c0             	setne  %al
    17bd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    17c1:	84 c0                	test   %al,%al
    17c3:	74 19                	je     17de <pipe1+0x134>
    17c5:	c7 44 24 04 4e 57 00 	movl   $0x574e,0x4(%esp)
    17cc:	00 
    17cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17d4:	e8 dc 35 00 00       	call   4db5 <printf>
    17d9:	e9 b5 00 00 00       	jmp    1893 <pipe1+0x1e9>
    17de:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    17e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17e8:	7c b9                	jl     17a3 <pipe1+0xf9>
    17ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17ed:	01 45 f4             	add    %eax,-0xc(%ebp)
    17f0:	d1 65 f0             	shll   -0x10(%ebp)
    17f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f6:	3d 00 20 00 00       	cmp    $0x2000,%eax
    17fb:	76 07                	jbe    1804 <pipe1+0x15a>
    17fd:	c7 45 f0 00 20 00 00 	movl   $0x2000,-0x10(%ebp)
    1804:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1807:	8b 55 f0             	mov    -0x10(%ebp),%edx
    180a:	89 54 24 08          	mov    %edx,0x8(%esp)
    180e:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    1815:	00 
    1816:	89 04 24             	mov    %eax,(%esp)
    1819:	e8 16 34 00 00       	call   4c34 <read>
    181e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1821:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1825:	0f 8f 6f ff ff ff    	jg     179a <pipe1+0xf0>
    182b:	81 7d f4 2d 14 00 00 	cmpl   $0x142d,-0xc(%ebp)
    1832:	74 20                	je     1854 <pipe1+0x1aa>
    1834:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1837:	89 44 24 08          	mov    %eax,0x8(%esp)
    183b:	c7 44 24 04 5c 57 00 	movl   $0x575c,0x4(%esp)
    1842:	00 
    1843:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184a:	e8 66 35 00 00       	call   4db5 <printf>
    184f:	e8 c8 33 00 00       	call   4c1c <exit>
    1854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1857:	89 04 24             	mov    %eax,(%esp)
    185a:	e8 e5 33 00 00       	call   4c44 <close>
    185f:	e8 c0 33 00 00       	call   4c24 <wait>
    1864:	c7 44 24 04 73 57 00 	movl   $0x5773,0x4(%esp)
    186b:	00 
    186c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1873:	e8 3d 35 00 00       	call   4db5 <printf>
    1878:	eb 19                	jmp    1893 <pipe1+0x1e9>
    187a:	c7 44 24 04 7d 57 00 	movl   $0x577d,0x4(%esp)
    1881:	00 
    1882:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1889:	e8 27 35 00 00       	call   4db5 <printf>
    188e:	e8 89 33 00 00       	call   4c1c <exit>
    1893:	c9                   	leave  
    1894:	c3                   	ret    

00001895 <preempt>:
    1895:	55                   	push   %ebp
    1896:	89 e5                	mov    %esp,%ebp
    1898:	83 ec 38             	sub    $0x38,%esp
    189b:	c7 44 24 04 8c 57 00 	movl   $0x578c,0x4(%esp)
    18a2:	00 
    18a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18aa:	e8 06 35 00 00       	call   4db5 <printf>
    18af:	e8 60 33 00 00       	call   4c14 <fork>
    18b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    18b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18bb:	75 02                	jne    18bf <preempt+0x2a>
    18bd:	eb fe                	jmp    18bd <preempt+0x28>
    18bf:	e8 50 33 00 00       	call   4c14 <fork>
    18c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18cb:	75 02                	jne    18cf <preempt+0x3a>
    18cd:	eb fe                	jmp    18cd <preempt+0x38>
    18cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    18d2:	89 04 24             	mov    %eax,(%esp)
    18d5:	e8 52 33 00 00       	call   4c2c <pipe>
    18da:	e8 35 33 00 00       	call   4c14 <fork>
    18df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e6:	75 4c                	jne    1934 <preempt+0x9f>
    18e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18eb:	89 04 24             	mov    %eax,(%esp)
    18ee:	e8 51 33 00 00       	call   4c44 <close>
    18f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18f6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    18fd:	00 
    18fe:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    1905:	00 
    1906:	89 04 24             	mov    %eax,(%esp)
    1909:	e8 2e 33 00 00       	call   4c3c <write>
    190e:	83 f8 01             	cmp    $0x1,%eax
    1911:	74 14                	je     1927 <preempt+0x92>
    1913:	c7 44 24 04 98 57 00 	movl   $0x5798,0x4(%esp)
    191a:	00 
    191b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1922:	e8 8e 34 00 00       	call   4db5 <printf>
    1927:	8b 45 e8             	mov    -0x18(%ebp),%eax
    192a:	89 04 24             	mov    %eax,(%esp)
    192d:	e8 12 33 00 00       	call   4c44 <close>
    1932:	eb fe                	jmp    1932 <preempt+0x9d>
    1934:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1937:	89 04 24             	mov    %eax,(%esp)
    193a:	e8 05 33 00 00       	call   4c44 <close>
    193f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1942:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1949:	00 
    194a:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    1951:	00 
    1952:	89 04 24             	mov    %eax,(%esp)
    1955:	e8 da 32 00 00       	call   4c34 <read>
    195a:	83 f8 01             	cmp    $0x1,%eax
    195d:	74 16                	je     1975 <preempt+0xe0>
    195f:	c7 44 24 04 ac 57 00 	movl   $0x57ac,0x4(%esp)
    1966:	00 
    1967:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    196e:	e8 42 34 00 00       	call   4db5 <printf>
    1973:	eb 77                	jmp    19ec <preempt+0x157>
    1975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1978:	89 04 24             	mov    %eax,(%esp)
    197b:	e8 c4 32 00 00       	call   4c44 <close>
    1980:	c7 44 24 04 bf 57 00 	movl   $0x57bf,0x4(%esp)
    1987:	00 
    1988:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    198f:	e8 21 34 00 00       	call   4db5 <printf>
    1994:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1997:	89 04 24             	mov    %eax,(%esp)
    199a:	e8 ad 32 00 00       	call   4c4c <kill>
    199f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19a2:	89 04 24             	mov    %eax,(%esp)
    19a5:	e8 a2 32 00 00       	call   4c4c <kill>
    19aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19ad:	89 04 24             	mov    %eax,(%esp)
    19b0:	e8 97 32 00 00       	call   4c4c <kill>
    19b5:	c7 44 24 04 c8 57 00 	movl   $0x57c8,0x4(%esp)
    19bc:	00 
    19bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19c4:	e8 ec 33 00 00       	call   4db5 <printf>
    19c9:	e8 56 32 00 00       	call   4c24 <wait>
    19ce:	e8 51 32 00 00       	call   4c24 <wait>
    19d3:	e8 4c 32 00 00       	call   4c24 <wait>
    19d8:	c7 44 24 04 d1 57 00 	movl   $0x57d1,0x4(%esp)
    19df:	00 
    19e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19e7:	e8 c9 33 00 00       	call   4db5 <printf>
    19ec:	c9                   	leave  
    19ed:	c3                   	ret    

000019ee <exitwait>:
    19ee:	55                   	push   %ebp
    19ef:	89 e5                	mov    %esp,%ebp
    19f1:	83 ec 28             	sub    $0x28,%esp
    19f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    19fb:	eb 53                	jmp    1a50 <exitwait+0x62>
    19fd:	e8 12 32 00 00       	call   4c14 <fork>
    1a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a09:	79 16                	jns    1a21 <exitwait+0x33>
    1a0b:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    1a12:	00 
    1a13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a1a:	e8 96 33 00 00       	call   4db5 <printf>
    1a1f:	eb 49                	jmp    1a6a <exitwait+0x7c>
    1a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a25:	74 20                	je     1a47 <exitwait+0x59>
    1a27:	e8 f8 31 00 00       	call   4c24 <wait>
    1a2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1a2f:	74 1b                	je     1a4c <exitwait+0x5e>
    1a31:	c7 44 24 04 ea 57 00 	movl   $0x57ea,0x4(%esp)
    1a38:	00 
    1a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a40:	e8 70 33 00 00       	call   4db5 <printf>
    1a45:	eb 23                	jmp    1a6a <exitwait+0x7c>
    1a47:	e8 d0 31 00 00       	call   4c1c <exit>
    1a4c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1a50:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
    1a54:	7e a7                	jle    19fd <exitwait+0xf>
    1a56:	c7 44 24 04 fa 57 00 	movl   $0x57fa,0x4(%esp)
    1a5d:	00 
    1a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a65:	e8 4b 33 00 00       	call   4db5 <printf>
    1a6a:	c9                   	leave  
    1a6b:	c3                   	ret    

00001a6c <mem>:
    1a6c:	55                   	push   %ebp
    1a6d:	89 e5                	mov    %esp,%ebp
    1a6f:	83 ec 28             	sub    $0x28,%esp
    1a72:	c7 44 24 04 07 58 00 	movl   $0x5807,0x4(%esp)
    1a79:	00 
    1a7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a81:	e8 2f 33 00 00       	call   4db5 <printf>
    1a86:	e8 11 32 00 00       	call   4c9c <getpid>
    1a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a8e:	e8 81 31 00 00       	call   4c14 <fork>
    1a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a9a:	0f 85 aa 00 00 00    	jne    1b4a <mem+0xde>
    1aa0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1aa7:	eb 0e                	jmp    1ab7 <mem+0x4b>
    1aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aac:	8b 55 e8             	mov    -0x18(%ebp),%edx
    1aaf:	89 10                	mov    %edx,(%eax)
    1ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1ab7:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    1abe:	e8 d8 35 00 00       	call   509b <malloc>
    1ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1ac6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1aca:	75 dd                	jne    1aa9 <mem+0x3d>
    1acc:	eb 19                	jmp    1ae7 <mem+0x7b>
    1ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ad1:	8b 00                	mov    (%eax),%eax
    1ad3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ad9:	89 04 24             	mov    %eax,(%esp)
    1adc:	e8 8b 34 00 00       	call   4f6c <free>
    1ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1ae7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1aeb:	75 e1                	jne    1ace <mem+0x62>
    1aed:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    1af4:	e8 a2 35 00 00       	call   509b <malloc>
    1af9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1afc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1b00:	75 24                	jne    1b26 <mem+0xba>
    1b02:	c7 44 24 04 11 58 00 	movl   $0x5811,0x4(%esp)
    1b09:	00 
    1b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b11:	e8 9f 32 00 00       	call   4db5 <printf>
    1b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b19:	89 04 24             	mov    %eax,(%esp)
    1b1c:	e8 2b 31 00 00       	call   4c4c <kill>
    1b21:	e8 f6 30 00 00       	call   4c1c <exit>
    1b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b29:	89 04 24             	mov    %eax,(%esp)
    1b2c:	e8 3b 34 00 00       	call   4f6c <free>
    1b31:	c7 44 24 04 2b 58 00 	movl   $0x582b,0x4(%esp)
    1b38:	00 
    1b39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b40:	e8 70 32 00 00       	call   4db5 <printf>
    1b45:	e8 d2 30 00 00       	call   4c1c <exit>
    1b4a:	e8 d5 30 00 00       	call   4c24 <wait>
    1b4f:	c9                   	leave  
    1b50:	c3                   	ret    

00001b51 <sharedfd>:
    1b51:	55                   	push   %ebp
    1b52:	89 e5                	mov    %esp,%ebp
    1b54:	83 ec 48             	sub    $0x48,%esp
    1b57:	c7 44 24 04 33 58 00 	movl   $0x5833,0x4(%esp)
    1b5e:	00 
    1b5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b66:	e8 4a 32 00 00       	call   4db5 <printf>
    1b6b:	c7 04 24 42 58 00 00 	movl   $0x5842,(%esp)
    1b72:	e8 f5 30 00 00       	call   4c6c <unlink>
    1b77:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1b7e:	00 
    1b7f:	c7 04 24 42 58 00 00 	movl   $0x5842,(%esp)
    1b86:	e8 d1 30 00 00       	call   4c5c <open>
    1b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1b8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1b92:	79 19                	jns    1bad <sharedfd+0x5c>
    1b94:	c7 44 24 04 4c 58 00 	movl   $0x584c,0x4(%esp)
    1b9b:	00 
    1b9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ba3:	e8 0d 32 00 00       	call   4db5 <printf>
    1ba8:	e9 9b 01 00 00       	jmp    1d48 <sharedfd+0x1f7>
    1bad:	e8 62 30 00 00       	call   4c14 <fork>
    1bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1bb9:	75 07                	jne    1bc2 <sharedfd+0x71>
    1bbb:	b8 63 00 00 00       	mov    $0x63,%eax
    1bc0:	eb 05                	jmp    1bc7 <sharedfd+0x76>
    1bc2:	b8 70 00 00 00       	mov    $0x70,%eax
    1bc7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1bce:	00 
    1bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bd3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1bd6:	89 04 24             	mov    %eax,(%esp)
    1bd9:	e8 98 2e 00 00       	call   4a76 <memset>
    1bde:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1be5:	eb 39                	jmp    1c20 <sharedfd+0xcf>
    1be7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1bee:	00 
    1bef:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1bf9:	89 04 24             	mov    %eax,(%esp)
    1bfc:	e8 3b 30 00 00       	call   4c3c <write>
    1c01:	83 f8 0a             	cmp    $0xa,%eax
    1c04:	74 16                	je     1c1c <sharedfd+0xcb>
    1c06:	c7 44 24 04 78 58 00 	movl   $0x5878,0x4(%esp)
    1c0d:	00 
    1c0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c15:	e8 9b 31 00 00       	call   4db5 <printf>
    1c1a:	eb 0d                	jmp    1c29 <sharedfd+0xd8>
    1c1c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1c20:	81 7d e8 e7 03 00 00 	cmpl   $0x3e7,-0x18(%ebp)
    1c27:	7e be                	jle    1be7 <sharedfd+0x96>
    1c29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1c2d:	75 05                	jne    1c34 <sharedfd+0xe3>
    1c2f:	e8 e8 2f 00 00       	call   4c1c <exit>
    1c34:	e8 eb 2f 00 00       	call   4c24 <wait>
    1c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1c3c:	89 04 24             	mov    %eax,(%esp)
    1c3f:	e8 00 30 00 00       	call   4c44 <close>
    1c44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c4b:	00 
    1c4c:	c7 04 24 42 58 00 00 	movl   $0x5842,(%esp)
    1c53:	e8 04 30 00 00       	call   4c5c <open>
    1c58:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1c5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1c5f:	79 19                	jns    1c7a <sharedfd+0x129>
    1c61:	c7 44 24 04 98 58 00 	movl   $0x5898,0x4(%esp)
    1c68:	00 
    1c69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c70:	e8 40 31 00 00       	call   4db5 <printf>
    1c75:	e9 ce 00 00 00       	jmp    1d48 <sharedfd+0x1f7>
    1c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1c87:	eb 35                	jmp    1cbe <sharedfd+0x16d>
    1c89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1c90:	eb 24                	jmp    1cb6 <sharedfd+0x165>
    1c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1c95:	0f b6 44 05 d6       	movzbl -0x2a(%ebp,%eax,1),%eax
    1c9a:	3c 63                	cmp    $0x63,%al
    1c9c:	75 04                	jne    1ca2 <sharedfd+0x151>
    1c9e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ca5:	0f b6 44 05 d6       	movzbl -0x2a(%ebp,%eax,1),%eax
    1caa:	3c 70                	cmp    $0x70,%al
    1cac:	75 04                	jne    1cb2 <sharedfd+0x161>
    1cae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cb2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1cb9:	83 f8 09             	cmp    $0x9,%eax
    1cbc:	76 d4                	jbe    1c92 <sharedfd+0x141>
    1cbe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1cc5:	00 
    1cc6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1cd0:	89 04 24             	mov    %eax,(%esp)
    1cd3:	e8 5c 2f 00 00       	call   4c34 <read>
    1cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1cdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cdf:	7f a8                	jg     1c89 <sharedfd+0x138>
    1ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1ce4:	89 04 24             	mov    %eax,(%esp)
    1ce7:	e8 58 2f 00 00       	call   4c44 <close>
    1cec:	c7 04 24 42 58 00 00 	movl   $0x5842,(%esp)
    1cf3:	e8 74 2f 00 00       	call   4c6c <unlink>
    1cf8:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1cff:	75 20                	jne    1d21 <sharedfd+0x1d0>
    1d01:	81 7d f4 10 27 00 00 	cmpl   $0x2710,-0xc(%ebp)
    1d08:	75 17                	jne    1d21 <sharedfd+0x1d0>
    1d0a:	c7 44 24 04 c3 58 00 	movl   $0x58c3,0x4(%esp)
    1d11:	00 
    1d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d19:	e8 97 30 00 00       	call   4db5 <printf>
    1d1e:	90                   	nop
    1d1f:	eb 27                	jmp    1d48 <sharedfd+0x1f7>
    1d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d24:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
    1d2f:	c7 44 24 04 d0 58 00 	movl   $0x58d0,0x4(%esp)
    1d36:	00 
    1d37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d3e:	e8 72 30 00 00       	call   4db5 <printf>
    1d43:	e8 d4 2e 00 00       	call   4c1c <exit>
    1d48:	c9                   	leave  
    1d49:	c3                   	ret    

00001d4a <twofiles>:
    1d4a:	55                   	push   %ebp
    1d4b:	89 e5                	mov    %esp,%ebp
    1d4d:	83 ec 38             	sub    $0x38,%esp
    1d50:	c7 44 24 04 e5 58 00 	movl   $0x58e5,0x4(%esp)
    1d57:	00 
    1d58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d5f:	e8 51 30 00 00       	call   4db5 <printf>
    1d64:	c7 04 24 f4 58 00 00 	movl   $0x58f4,(%esp)
    1d6b:	e8 fc 2e 00 00       	call   4c6c <unlink>
    1d70:	c7 04 24 f7 58 00 00 	movl   $0x58f7,(%esp)
    1d77:	e8 f0 2e 00 00       	call   4c6c <unlink>
    1d7c:	e8 93 2e 00 00       	call   4c14 <fork>
    1d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1d88:	79 19                	jns    1da3 <twofiles+0x59>
    1d8a:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    1d91:	00 
    1d92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d99:	e8 17 30 00 00       	call   4db5 <printf>
    1d9e:	e8 79 2e 00 00       	call   4c1c <exit>
    1da3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1da7:	74 07                	je     1db0 <twofiles+0x66>
    1da9:	b8 f4 58 00 00       	mov    $0x58f4,%eax
    1dae:	eb 05                	jmp    1db5 <twofiles+0x6b>
    1db0:	b8 f7 58 00 00       	mov    $0x58f7,%eax
    1db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1db8:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1dbf:	00 
    1dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dc3:	89 04 24             	mov    %eax,(%esp)
    1dc6:	e8 91 2e 00 00       	call   4c5c <open>
    1dcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1dce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1dd2:	79 19                	jns    1ded <twofiles+0xa3>
    1dd4:	c7 44 24 04 fa 58 00 	movl   $0x58fa,0x4(%esp)
    1ddb:	00 
    1ddc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1de3:	e8 cd 2f 00 00       	call   4db5 <printf>
    1de8:	e8 2f 2e 00 00       	call   4c1c <exit>
    1ded:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1df1:	74 07                	je     1dfa <twofiles+0xb0>
    1df3:	b8 70 00 00 00       	mov    $0x70,%eax
    1df8:	eb 05                	jmp    1dff <twofiles+0xb5>
    1dfa:	b8 63 00 00 00       	mov    $0x63,%eax
    1dff:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1e06:	00 
    1e07:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e0b:	c7 04 24 e0 92 00 00 	movl   $0x92e0,(%esp)
    1e12:	e8 5f 2c 00 00       	call   4a76 <memset>
    1e17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1e1e:	eb 4b                	jmp    1e6b <twofiles+0x121>
    1e20:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1e27:	00 
    1e28:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    1e2f:	00 
    1e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1e33:	89 04 24             	mov    %eax,(%esp)
    1e36:	e8 01 2e 00 00       	call   4c3c <write>
    1e3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1e3e:	81 7d ec f4 01 00 00 	cmpl   $0x1f4,-0x14(%ebp)
    1e45:	74 20                	je     1e67 <twofiles+0x11d>
    1e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1e4a:	89 44 24 08          	mov    %eax,0x8(%esp)
    1e4e:	c7 44 24 04 09 59 00 	movl   $0x5909,0x4(%esp)
    1e55:	00 
    1e56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e5d:	e8 53 2f 00 00       	call   4db5 <printf>
    1e62:	e8 b5 2d 00 00       	call   4c1c <exit>
    1e67:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    1e6b:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%ebp)
    1e6f:	7e af                	jle    1e20 <twofiles+0xd6>
    1e71:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1e74:	89 04 24             	mov    %eax,(%esp)
    1e77:	e8 c8 2d 00 00       	call   4c44 <close>
    1e7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1e80:	74 11                	je     1e93 <twofiles+0x149>
    1e82:	e8 9d 2d 00 00       	call   4c24 <wait>
    1e87:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1e8e:	e9 e6 00 00 00       	jmp    1f79 <twofiles+0x22f>
    1e93:	e8 84 2d 00 00       	call   4c1c <exit>
    1e98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1e9c:	74 07                	je     1ea5 <twofiles+0x15b>
    1e9e:	b8 f4 58 00 00       	mov    $0x58f4,%eax
    1ea3:	eb 05                	jmp    1eaa <twofiles+0x160>
    1ea5:	b8 f7 58 00 00       	mov    $0x58f7,%eax
    1eaa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1eb1:	00 
    1eb2:	89 04 24             	mov    %eax,(%esp)
    1eb5:	e8 a2 2d 00 00       	call   4c5c <open>
    1eba:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1ebd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1ec4:	eb 57                	jmp    1f1d <twofiles+0x1d3>
    1ec6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1ecd:	eb 40                	jmp    1f0f <twofiles+0x1c5>
    1ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ed2:	0f b6 80 e0 92 00 00 	movzbl 0x92e0(%eax),%eax
    1ed9:	0f be d0             	movsbl %al,%edx
    1edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1ee0:	74 07                	je     1ee9 <twofiles+0x19f>
    1ee2:	b8 70 00 00 00       	mov    $0x70,%eax
    1ee7:	eb 05                	jmp    1eee <twofiles+0x1a4>
    1ee9:	b8 63 00 00 00       	mov    $0x63,%eax
    1eee:	39 c2                	cmp    %eax,%edx
    1ef0:	74 19                	je     1f0b <twofiles+0x1c1>
    1ef2:	c7 44 24 04 1a 59 00 	movl   $0x591a,0x4(%esp)
    1ef9:	00 
    1efa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f01:	e8 af 2e 00 00       	call   4db5 <printf>
    1f06:	e8 11 2d 00 00       	call   4c1c <exit>
    1f0b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1f0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1f12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1f15:	7c b8                	jl     1ecf <twofiles+0x185>
    1f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1f1a:	01 45 f0             	add    %eax,-0x10(%ebp)
    1f1d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1f24:	00 
    1f25:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    1f2c:	00 
    1f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1f30:	89 04 24             	mov    %eax,(%esp)
    1f33:	e8 fc 2c 00 00       	call   4c34 <read>
    1f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1f3f:	7f 85                	jg     1ec6 <twofiles+0x17c>
    1f41:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1f44:	89 04 24             	mov    %eax,(%esp)
    1f47:	e8 f8 2c 00 00       	call   4c44 <close>
    1f4c:	81 7d f0 70 17 00 00 	cmpl   $0x1770,-0x10(%ebp)
    1f53:	74 20                	je     1f75 <twofiles+0x22b>
    1f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1f58:	89 44 24 08          	mov    %eax,0x8(%esp)
    1f5c:	c7 44 24 04 26 59 00 	movl   $0x5926,0x4(%esp)
    1f63:	00 
    1f64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f6b:	e8 45 2e 00 00       	call   4db5 <printf>
    1f70:	e8 a7 2c 00 00       	call   4c1c <exit>
    1f75:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    1f79:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1f7d:	0f 8e 15 ff ff ff    	jle    1e98 <twofiles+0x14e>
    1f83:	c7 04 24 f4 58 00 00 	movl   $0x58f4,(%esp)
    1f8a:	e8 dd 2c 00 00       	call   4c6c <unlink>
    1f8f:	c7 04 24 f7 58 00 00 	movl   $0x58f7,(%esp)
    1f96:	e8 d1 2c 00 00       	call   4c6c <unlink>
    1f9b:	c7 44 24 04 37 59 00 	movl   $0x5937,0x4(%esp)
    1fa2:	00 
    1fa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1faa:	e8 06 2e 00 00       	call   4db5 <printf>
    1faf:	c9                   	leave  
    1fb0:	c3                   	ret    

00001fb1 <createdelete>:
    1fb1:	55                   	push   %ebp
    1fb2:	89 e5                	mov    %esp,%ebp
    1fb4:	83 ec 48             	sub    $0x48,%esp
    1fb7:	c7 44 24 04 44 59 00 	movl   $0x5944,0x4(%esp)
    1fbe:	00 
    1fbf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fc6:	e8 ea 2d 00 00       	call   4db5 <printf>
    1fcb:	e8 44 2c 00 00       	call   4c14 <fork>
    1fd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1fd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1fd7:	79 19                	jns    1ff2 <createdelete+0x41>
    1fd9:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    1fe0:	00 
    1fe1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fe8:	e8 c8 2d 00 00       	call   4db5 <printf>
    1fed:	e8 2a 2c 00 00       	call   4c1c <exit>
    1ff2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ff6:	74 07                	je     1fff <createdelete+0x4e>
    1ff8:	b8 70 00 00 00       	mov    $0x70,%eax
    1ffd:	eb 05                	jmp    2004 <createdelete+0x53>
    1fff:	b8 63 00 00 00       	mov    $0x63,%eax
    2004:	88 45 cc             	mov    %al,-0x34(%ebp)
    2007:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
    200b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2012:	e9 98 00 00 00       	jmp    20af <createdelete+0xfe>
    2017:	8b 45 f0             	mov    -0x10(%ebp),%eax
    201a:	83 c0 30             	add    $0x30,%eax
    201d:	88 45 cd             	mov    %al,-0x33(%ebp)
    2020:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2027:	00 
    2028:	8d 45 cc             	lea    -0x34(%ebp),%eax
    202b:	89 04 24             	mov    %eax,(%esp)
    202e:	e8 29 2c 00 00       	call   4c5c <open>
    2033:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    203a:	79 19                	jns    2055 <createdelete+0xa4>
    203c:	c7 44 24 04 fa 58 00 	movl   $0x58fa,0x4(%esp)
    2043:	00 
    2044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    204b:	e8 65 2d 00 00       	call   4db5 <printf>
    2050:	e8 c7 2b 00 00       	call   4c1c <exit>
    2055:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2058:	89 04 24             	mov    %eax,(%esp)
    205b:	e8 e4 2b 00 00       	call   4c44 <close>
    2060:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2064:	7e 45                	jle    20ab <createdelete+0xfa>
    2066:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2069:	83 e0 01             	and    $0x1,%eax
    206c:	85 c0                	test   %eax,%eax
    206e:	75 3b                	jne    20ab <createdelete+0xfa>
    2070:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2073:	89 c2                	mov    %eax,%edx
    2075:	c1 ea 1f             	shr    $0x1f,%edx
    2078:	8d 04 02             	lea    (%edx,%eax,1),%eax
    207b:	d1 f8                	sar    %eax
    207d:	83 c0 30             	add    $0x30,%eax
    2080:	88 45 cd             	mov    %al,-0x33(%ebp)
    2083:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2086:	89 04 24             	mov    %eax,(%esp)
    2089:	e8 de 2b 00 00       	call   4c6c <unlink>
    208e:	85 c0                	test   %eax,%eax
    2090:	79 19                	jns    20ab <createdelete+0xfa>
    2092:	c7 44 24 04 57 59 00 	movl   $0x5957,0x4(%esp)
    2099:	00 
    209a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20a1:	e8 0f 2d 00 00       	call   4db5 <printf>
    20a6:	e8 71 2b 00 00       	call   4c1c <exit>
    20ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    20af:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
    20b3:	0f 8e 5e ff ff ff    	jle    2017 <createdelete+0x66>
    20b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    20bd:	75 05                	jne    20c4 <createdelete+0x113>
    20bf:	e8 58 2b 00 00       	call   4c1c <exit>
    20c4:	e8 5b 2b 00 00       	call   4c24 <wait>
    20c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    20d0:	e9 34 01 00 00       	jmp    2209 <createdelete+0x258>
    20d5:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    20d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    20dc:	83 c0 30             	add    $0x30,%eax
    20df:	88 45 cd             	mov    %al,-0x33(%ebp)
    20e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20e9:	00 
    20ea:	8d 45 cc             	lea    -0x34(%ebp),%eax
    20ed:	89 04 24             	mov    %eax,(%esp)
    20f0:	e8 67 2b 00 00       	call   4c5c <open>
    20f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    20f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    20fc:	74 06                	je     2104 <createdelete+0x153>
    20fe:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    2102:	7e 26                	jle    212a <createdelete+0x179>
    2104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2108:	79 20                	jns    212a <createdelete+0x179>
    210a:	8d 45 cc             	lea    -0x34(%ebp),%eax
    210d:	89 44 24 08          	mov    %eax,0x8(%esp)
    2111:	c7 44 24 04 68 59 00 	movl   $0x5968,0x4(%esp)
    2118:	00 
    2119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2120:	e8 90 2c 00 00       	call   4db5 <printf>
    2125:	e8 f2 2a 00 00       	call   4c1c <exit>
    212a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    212e:	7e 2c                	jle    215c <createdelete+0x1ab>
    2130:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    2134:	7f 26                	jg     215c <createdelete+0x1ab>
    2136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    213a:	78 20                	js     215c <createdelete+0x1ab>
    213c:	8d 45 cc             	lea    -0x34(%ebp),%eax
    213f:	89 44 24 08          	mov    %eax,0x8(%esp)
    2143:	c7 44 24 04 8c 59 00 	movl   $0x598c,0x4(%esp)
    214a:	00 
    214b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2152:	e8 5e 2c 00 00       	call   4db5 <printf>
    2157:	e8 c0 2a 00 00       	call   4c1c <exit>
    215c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2160:	78 0b                	js     216d <createdelete+0x1bc>
    2162:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2165:	89 04 24             	mov    %eax,(%esp)
    2168:	e8 d7 2a 00 00       	call   4c44 <close>
    216d:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    2171:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2174:	83 c0 30             	add    $0x30,%eax
    2177:	88 45 cd             	mov    %al,-0x33(%ebp)
    217a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2181:	00 
    2182:	8d 45 cc             	lea    -0x34(%ebp),%eax
    2185:	89 04 24             	mov    %eax,(%esp)
    2188:	e8 cf 2a 00 00       	call   4c5c <open>
    218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2190:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2194:	74 06                	je     219c <createdelete+0x1eb>
    2196:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    219a:	7e 26                	jle    21c2 <createdelete+0x211>
    219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    21a0:	79 20                	jns    21c2 <createdelete+0x211>
    21a2:	8d 45 cc             	lea    -0x34(%ebp),%eax
    21a5:	89 44 24 08          	mov    %eax,0x8(%esp)
    21a9:	c7 44 24 04 68 59 00 	movl   $0x5968,0x4(%esp)
    21b0:	00 
    21b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21b8:	e8 f8 2b 00 00       	call   4db5 <printf>
    21bd:	e8 5a 2a 00 00       	call   4c1c <exit>
    21c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    21c6:	7e 2c                	jle    21f4 <createdelete+0x243>
    21c8:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    21cc:	7f 26                	jg     21f4 <createdelete+0x243>
    21ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    21d2:	78 20                	js     21f4 <createdelete+0x243>
    21d4:	8d 45 cc             	lea    -0x34(%ebp),%eax
    21d7:	89 44 24 08          	mov    %eax,0x8(%esp)
    21db:	c7 44 24 04 8c 59 00 	movl   $0x598c,0x4(%esp)
    21e2:	00 
    21e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21ea:	e8 c6 2b 00 00       	call   4db5 <printf>
    21ef:	e8 28 2a 00 00       	call   4c1c <exit>
    21f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    21f8:	78 0b                	js     2205 <createdelete+0x254>
    21fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    21fd:	89 04 24             	mov    %eax,(%esp)
    2200:	e8 3f 2a 00 00       	call   4c44 <close>
    2205:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2209:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
    220d:	0f 8e c2 fe ff ff    	jle    20d5 <createdelete+0x124>
    2213:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    221a:	eb 2b                	jmp    2247 <createdelete+0x296>
    221c:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    2220:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2223:	83 c0 30             	add    $0x30,%eax
    2226:	88 45 cd             	mov    %al,-0x33(%ebp)
    2229:	8d 45 cc             	lea    -0x34(%ebp),%eax
    222c:	89 04 24             	mov    %eax,(%esp)
    222f:	e8 38 2a 00 00       	call   4c6c <unlink>
    2234:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    2238:	8d 45 cc             	lea    -0x34(%ebp),%eax
    223b:	89 04 24             	mov    %eax,(%esp)
    223e:	e8 29 2a 00 00       	call   4c6c <unlink>
    2243:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2247:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
    224b:	7e cf                	jle    221c <createdelete+0x26b>
    224d:	c7 44 24 04 ac 59 00 	movl   $0x59ac,0x4(%esp)
    2254:	00 
    2255:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    225c:	e8 54 2b 00 00       	call   4db5 <printf>
    2261:	c9                   	leave  
    2262:	c3                   	ret    

00002263 <unlinkread>:
    2263:	55                   	push   %ebp
    2264:	89 e5                	mov    %esp,%ebp
    2266:	83 ec 28             	sub    $0x28,%esp
    2269:	c7 44 24 04 bd 59 00 	movl   $0x59bd,0x4(%esp)
    2270:	00 
    2271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2278:	e8 38 2b 00 00       	call   4db5 <printf>
    227d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2284:	00 
    2285:	c7 04 24 ce 59 00 00 	movl   $0x59ce,(%esp)
    228c:	e8 cb 29 00 00       	call   4c5c <open>
    2291:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2298:	79 19                	jns    22b3 <unlinkread+0x50>
    229a:	c7 44 24 04 d9 59 00 	movl   $0x59d9,0x4(%esp)
    22a1:	00 
    22a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22a9:	e8 07 2b 00 00       	call   4db5 <printf>
    22ae:	e8 69 29 00 00       	call   4c1c <exit>
    22b3:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    22ba:	00 
    22bb:	c7 44 24 04 f3 59 00 	movl   $0x59f3,0x4(%esp)
    22c2:	00 
    22c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    22c6:	89 04 24             	mov    %eax,(%esp)
    22c9:	e8 6e 29 00 00       	call   4c3c <write>
    22ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    22d1:	89 04 24             	mov    %eax,(%esp)
    22d4:	e8 6b 29 00 00       	call   4c44 <close>
    22d9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    22e0:	00 
    22e1:	c7 04 24 ce 59 00 00 	movl   $0x59ce,(%esp)
    22e8:	e8 6f 29 00 00       	call   4c5c <open>
    22ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    22f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    22f4:	79 19                	jns    230f <unlinkread+0xac>
    22f6:	c7 44 24 04 f9 59 00 	movl   $0x59f9,0x4(%esp)
    22fd:	00 
    22fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2305:	e8 ab 2a 00 00       	call   4db5 <printf>
    230a:	e8 0d 29 00 00       	call   4c1c <exit>
    230f:	c7 04 24 ce 59 00 00 	movl   $0x59ce,(%esp)
    2316:	e8 51 29 00 00       	call   4c6c <unlink>
    231b:	85 c0                	test   %eax,%eax
    231d:	74 19                	je     2338 <unlinkread+0xd5>
    231f:	c7 44 24 04 11 5a 00 	movl   $0x5a11,0x4(%esp)
    2326:	00 
    2327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    232e:	e8 82 2a 00 00       	call   4db5 <printf>
    2333:	e8 e4 28 00 00       	call   4c1c <exit>
    2338:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    233f:	00 
    2340:	c7 04 24 ce 59 00 00 	movl   $0x59ce,(%esp)
    2347:	e8 10 29 00 00       	call   4c5c <open>
    234c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    234f:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    2356:	00 
    2357:	c7 44 24 04 2b 5a 00 	movl   $0x5a2b,0x4(%esp)
    235e:	00 
    235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2362:	89 04 24             	mov    %eax,(%esp)
    2365:	e8 d2 28 00 00       	call   4c3c <write>
    236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    236d:	89 04 24             	mov    %eax,(%esp)
    2370:	e8 cf 28 00 00       	call   4c44 <close>
    2375:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    237c:	00 
    237d:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    2384:	00 
    2385:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2388:	89 04 24             	mov    %eax,(%esp)
    238b:	e8 a4 28 00 00       	call   4c34 <read>
    2390:	83 f8 05             	cmp    $0x5,%eax
    2393:	74 19                	je     23ae <unlinkread+0x14b>
    2395:	c7 44 24 04 2f 5a 00 	movl   $0x5a2f,0x4(%esp)
    239c:	00 
    239d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23a4:	e8 0c 2a 00 00       	call   4db5 <printf>
    23a9:	e8 6e 28 00 00       	call   4c1c <exit>
    23ae:	0f b6 05 e0 92 00 00 	movzbl 0x92e0,%eax
    23b5:	3c 68                	cmp    $0x68,%al
    23b7:	74 19                	je     23d2 <unlinkread+0x16f>
    23b9:	c7 44 24 04 46 5a 00 	movl   $0x5a46,0x4(%esp)
    23c0:	00 
    23c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23c8:	e8 e8 29 00 00       	call   4db5 <printf>
    23cd:	e8 4a 28 00 00       	call   4c1c <exit>
    23d2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    23d9:	00 
    23da:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    23e1:	00 
    23e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23e5:	89 04 24             	mov    %eax,(%esp)
    23e8:	e8 4f 28 00 00       	call   4c3c <write>
    23ed:	83 f8 0a             	cmp    $0xa,%eax
    23f0:	74 19                	je     240b <unlinkread+0x1a8>
    23f2:	c7 44 24 04 5d 5a 00 	movl   $0x5a5d,0x4(%esp)
    23f9:	00 
    23fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2401:	e8 af 29 00 00       	call   4db5 <printf>
    2406:	e8 11 28 00 00       	call   4c1c <exit>
    240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    240e:	89 04 24             	mov    %eax,(%esp)
    2411:	e8 2e 28 00 00       	call   4c44 <close>
    2416:	c7 04 24 ce 59 00 00 	movl   $0x59ce,(%esp)
    241d:	e8 4a 28 00 00       	call   4c6c <unlink>
    2422:	c7 44 24 04 76 5a 00 	movl   $0x5a76,0x4(%esp)
    2429:	00 
    242a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2431:	e8 7f 29 00 00       	call   4db5 <printf>
    2436:	c9                   	leave  
    2437:	c3                   	ret    

00002438 <linktest>:
    2438:	55                   	push   %ebp
    2439:	89 e5                	mov    %esp,%ebp
    243b:	83 ec 28             	sub    $0x28,%esp
    243e:	c7 44 24 04 85 5a 00 	movl   $0x5a85,0x4(%esp)
    2445:	00 
    2446:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    244d:	e8 63 29 00 00       	call   4db5 <printf>
    2452:	c7 04 24 8f 5a 00 00 	movl   $0x5a8f,(%esp)
    2459:	e8 0e 28 00 00       	call   4c6c <unlink>
    245e:	c7 04 24 93 5a 00 00 	movl   $0x5a93,(%esp)
    2465:	e8 02 28 00 00       	call   4c6c <unlink>
    246a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2471:	00 
    2472:	c7 04 24 8f 5a 00 00 	movl   $0x5a8f,(%esp)
    2479:	e8 de 27 00 00       	call   4c5c <open>
    247e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2485:	79 19                	jns    24a0 <linktest+0x68>
    2487:	c7 44 24 04 97 5a 00 	movl   $0x5a97,0x4(%esp)
    248e:	00 
    248f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2496:	e8 1a 29 00 00       	call   4db5 <printf>
    249b:	e8 7c 27 00 00       	call   4c1c <exit>
    24a0:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    24a7:	00 
    24a8:	c7 44 24 04 f3 59 00 	movl   $0x59f3,0x4(%esp)
    24af:	00 
    24b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24b3:	89 04 24             	mov    %eax,(%esp)
    24b6:	e8 81 27 00 00       	call   4c3c <write>
    24bb:	83 f8 05             	cmp    $0x5,%eax
    24be:	74 19                	je     24d9 <linktest+0xa1>
    24c0:	c7 44 24 04 aa 5a 00 	movl   $0x5aaa,0x4(%esp)
    24c7:	00 
    24c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24cf:	e8 e1 28 00 00       	call   4db5 <printf>
    24d4:	e8 43 27 00 00       	call   4c1c <exit>
    24d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24dc:	89 04 24             	mov    %eax,(%esp)
    24df:	e8 60 27 00 00       	call   4c44 <close>
    24e4:	c7 44 24 04 93 5a 00 	movl   $0x5a93,0x4(%esp)
    24eb:	00 
    24ec:	c7 04 24 8f 5a 00 00 	movl   $0x5a8f,(%esp)
    24f3:	e8 84 27 00 00       	call   4c7c <link>
    24f8:	85 c0                	test   %eax,%eax
    24fa:	79 19                	jns    2515 <linktest+0xdd>
    24fc:	c7 44 24 04 bc 5a 00 	movl   $0x5abc,0x4(%esp)
    2503:	00 
    2504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    250b:	e8 a5 28 00 00       	call   4db5 <printf>
    2510:	e8 07 27 00 00       	call   4c1c <exit>
    2515:	c7 04 24 8f 5a 00 00 	movl   $0x5a8f,(%esp)
    251c:	e8 4b 27 00 00       	call   4c6c <unlink>
    2521:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2528:	00 
    2529:	c7 04 24 8f 5a 00 00 	movl   $0x5a8f,(%esp)
    2530:	e8 27 27 00 00       	call   4c5c <open>
    2535:	85 c0                	test   %eax,%eax
    2537:	78 19                	js     2552 <linktest+0x11a>
    2539:	c7 44 24 04 d4 5a 00 	movl   $0x5ad4,0x4(%esp)
    2540:	00 
    2541:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2548:	e8 68 28 00 00       	call   4db5 <printf>
    254d:	e8 ca 26 00 00       	call   4c1c <exit>
    2552:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2559:	00 
    255a:	c7 04 24 93 5a 00 00 	movl   $0x5a93,(%esp)
    2561:	e8 f6 26 00 00       	call   4c5c <open>
    2566:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    256d:	79 19                	jns    2588 <linktest+0x150>
    256f:	c7 44 24 04 f9 5a 00 	movl   $0x5af9,0x4(%esp)
    2576:	00 
    2577:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    257e:	e8 32 28 00 00       	call   4db5 <printf>
    2583:	e8 94 26 00 00       	call   4c1c <exit>
    2588:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    258f:	00 
    2590:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    2597:	00 
    2598:	8b 45 f4             	mov    -0xc(%ebp),%eax
    259b:	89 04 24             	mov    %eax,(%esp)
    259e:	e8 91 26 00 00       	call   4c34 <read>
    25a3:	83 f8 05             	cmp    $0x5,%eax
    25a6:	74 19                	je     25c1 <linktest+0x189>
    25a8:	c7 44 24 04 0a 5b 00 	movl   $0x5b0a,0x4(%esp)
    25af:	00 
    25b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25b7:	e8 f9 27 00 00       	call   4db5 <printf>
    25bc:	e8 5b 26 00 00       	call   4c1c <exit>
    25c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25c4:	89 04 24             	mov    %eax,(%esp)
    25c7:	e8 78 26 00 00       	call   4c44 <close>
    25cc:	c7 44 24 04 93 5a 00 	movl   $0x5a93,0x4(%esp)
    25d3:	00 
    25d4:	c7 04 24 93 5a 00 00 	movl   $0x5a93,(%esp)
    25db:	e8 9c 26 00 00       	call   4c7c <link>
    25e0:	85 c0                	test   %eax,%eax
    25e2:	78 19                	js     25fd <linktest+0x1c5>
    25e4:	c7 44 24 04 1b 5b 00 	movl   $0x5b1b,0x4(%esp)
    25eb:	00 
    25ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25f3:	e8 bd 27 00 00       	call   4db5 <printf>
    25f8:	e8 1f 26 00 00       	call   4c1c <exit>
    25fd:	c7 04 24 93 5a 00 00 	movl   $0x5a93,(%esp)
    2604:	e8 63 26 00 00       	call   4c6c <unlink>
    2609:	c7 44 24 04 8f 5a 00 	movl   $0x5a8f,0x4(%esp)
    2610:	00 
    2611:	c7 04 24 93 5a 00 00 	movl   $0x5a93,(%esp)
    2618:	e8 5f 26 00 00       	call   4c7c <link>
    261d:	85 c0                	test   %eax,%eax
    261f:	78 19                	js     263a <linktest+0x202>
    2621:	c7 44 24 04 3c 5b 00 	movl   $0x5b3c,0x4(%esp)
    2628:	00 
    2629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2630:	e8 80 27 00 00       	call   4db5 <printf>
    2635:	e8 e2 25 00 00       	call   4c1c <exit>
    263a:	c7 44 24 04 8f 5a 00 	movl   $0x5a8f,0x4(%esp)
    2641:	00 
    2642:	c7 04 24 5f 5b 00 00 	movl   $0x5b5f,(%esp)
    2649:	e8 2e 26 00 00       	call   4c7c <link>
    264e:	85 c0                	test   %eax,%eax
    2650:	78 19                	js     266b <linktest+0x233>
    2652:	c7 44 24 04 61 5b 00 	movl   $0x5b61,0x4(%esp)
    2659:	00 
    265a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2661:	e8 4f 27 00 00       	call   4db5 <printf>
    2666:	e8 b1 25 00 00       	call   4c1c <exit>
    266b:	c7 44 24 04 7d 5b 00 	movl   $0x5b7d,0x4(%esp)
    2672:	00 
    2673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    267a:	e8 36 27 00 00       	call   4db5 <printf>
    267f:	c9                   	leave  
    2680:	c3                   	ret    

00002681 <concreate>:
    2681:	55                   	push   %ebp
    2682:	89 e5                	mov    %esp,%ebp
    2684:	83 ec 68             	sub    $0x68,%esp
    2687:	c7 44 24 04 8a 5b 00 	movl   $0x5b8a,0x4(%esp)
    268e:	00 
    268f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2696:	e8 1a 27 00 00       	call   4db5 <printf>
    269b:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
    269f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    26a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    26aa:	e9 f7 00 00 00       	jmp    27a6 <concreate+0x125>
    26af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26b2:	83 c0 30             	add    $0x30,%eax
    26b5:	88 45 e6             	mov    %al,-0x1a(%ebp)
    26b8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    26bb:	89 04 24             	mov    %eax,(%esp)
    26be:	e8 a9 25 00 00       	call   4c6c <unlink>
    26c3:	e8 4c 25 00 00       	call   4c14 <fork>
    26c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    26cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    26cf:	74 3a                	je     270b <concreate+0x8a>
    26d1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    26d4:	ba 56 55 55 55       	mov    $0x55555556,%edx
    26d9:	89 c8                	mov    %ecx,%eax
    26db:	f7 ea                	imul   %edx
    26dd:	89 c8                	mov    %ecx,%eax
    26df:	c1 f8 1f             	sar    $0x1f,%eax
    26e2:	29 c2                	sub    %eax,%edx
    26e4:	89 d0                	mov    %edx,%eax
    26e6:	01 c0                	add    %eax,%eax
    26e8:	01 d0                	add    %edx,%eax
    26ea:	89 ca                	mov    %ecx,%edx
    26ec:	29 c2                	sub    %eax,%edx
    26ee:	83 fa 01             	cmp    $0x1,%edx
    26f1:	75 18                	jne    270b <concreate+0x8a>
    26f3:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    26f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    26fa:	c7 04 24 9a 5b 00 00 	movl   $0x5b9a,(%esp)
    2701:	e8 76 25 00 00       	call   4c7c <link>
    2706:	e9 87 00 00 00       	jmp    2792 <concreate+0x111>
    270b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    270f:	75 3a                	jne    274b <concreate+0xca>
    2711:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    2714:	ba 67 66 66 66       	mov    $0x66666667,%edx
    2719:	89 c8                	mov    %ecx,%eax
    271b:	f7 ea                	imul   %edx
    271d:	d1 fa                	sar    %edx
    271f:	89 c8                	mov    %ecx,%eax
    2721:	c1 f8 1f             	sar    $0x1f,%eax
    2724:	29 c2                	sub    %eax,%edx
    2726:	89 d0                	mov    %edx,%eax
    2728:	c1 e0 02             	shl    $0x2,%eax
    272b:	01 d0                	add    %edx,%eax
    272d:	89 ca                	mov    %ecx,%edx
    272f:	29 c2                	sub    %eax,%edx
    2731:	83 fa 01             	cmp    $0x1,%edx
    2734:	75 15                	jne    274b <concreate+0xca>
    2736:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2739:	89 44 24 04          	mov    %eax,0x4(%esp)
    273d:	c7 04 24 9a 5b 00 00 	movl   $0x5b9a,(%esp)
    2744:	e8 33 25 00 00       	call   4c7c <link>
    2749:	eb 47                	jmp    2792 <concreate+0x111>
    274b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2752:	00 
    2753:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2756:	89 04 24             	mov    %eax,(%esp)
    2759:	e8 fe 24 00 00       	call   4c5c <open>
    275e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2765:	79 20                	jns    2787 <concreate+0x106>
    2767:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    276a:	89 44 24 08          	mov    %eax,0x8(%esp)
    276e:	c7 44 24 04 9d 5b 00 	movl   $0x5b9d,0x4(%esp)
    2775:	00 
    2776:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    277d:	e8 33 26 00 00       	call   4db5 <printf>
    2782:	e8 95 24 00 00       	call   4c1c <exit>
    2787:	8b 45 f4             	mov    -0xc(%ebp),%eax
    278a:	89 04 24             	mov    %eax,(%esp)
    278d:	e8 b2 24 00 00       	call   4c44 <close>
    2792:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2796:	75 05                	jne    279d <concreate+0x11c>
    2798:	e8 7f 24 00 00       	call   4c1c <exit>
    279d:	e8 82 24 00 00       	call   4c24 <wait>
    27a2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    27a6:	83 7d e8 27          	cmpl   $0x27,-0x18(%ebp)
    27aa:	0f 8e ff fe ff ff    	jle    26af <concreate+0x2e>
    27b0:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    27b7:	00 
    27b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27bf:	00 
    27c0:	8d 45 bd             	lea    -0x43(%ebp),%eax
    27c3:	89 04 24             	mov    %eax,(%esp)
    27c6:	e8 ab 22 00 00       	call   4a76 <memset>
    27cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27d2:	00 
    27d3:	c7 04 24 5f 5b 00 00 	movl   $0x5b5f,(%esp)
    27da:	e8 7d 24 00 00       	call   4c5c <open>
    27df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    27e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    27e9:	e9 9d 00 00 00       	jmp    288b <concreate+0x20a>
    27ee:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    27f2:	66 85 c0             	test   %ax,%ax
    27f5:	0f 84 8f 00 00 00    	je     288a <concreate+0x209>
    27fb:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    27ff:	3c 43                	cmp    $0x43,%al
    2801:	0f 85 84 00 00 00    	jne    288b <concreate+0x20a>
    2807:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    280b:	84 c0                	test   %al,%al
    280d:	75 7c                	jne    288b <concreate+0x20a>
    280f:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    2813:	0f be c0             	movsbl %al,%eax
    2816:	83 e8 30             	sub    $0x30,%eax
    2819:	89 45 e8             	mov    %eax,-0x18(%ebp)
    281c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2820:	78 08                	js     282a <concreate+0x1a9>
    2822:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2825:	83 f8 27             	cmp    $0x27,%eax
    2828:	76 23                	jbe    284d <concreate+0x1cc>
    282a:	8d 45 ac             	lea    -0x54(%ebp),%eax
    282d:	83 c0 02             	add    $0x2,%eax
    2830:	89 44 24 08          	mov    %eax,0x8(%esp)
    2834:	c7 44 24 04 b9 5b 00 	movl   $0x5bb9,0x4(%esp)
    283b:	00 
    283c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2843:	e8 6d 25 00 00       	call   4db5 <printf>
    2848:	e8 cf 23 00 00       	call   4c1c <exit>
    284d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2850:	0f b6 44 05 bd       	movzbl -0x43(%ebp,%eax,1),%eax
    2855:	84 c0                	test   %al,%al
    2857:	74 23                	je     287c <concreate+0x1fb>
    2859:	8d 45 ac             	lea    -0x54(%ebp),%eax
    285c:	83 c0 02             	add    $0x2,%eax
    285f:	89 44 24 08          	mov    %eax,0x8(%esp)
    2863:	c7 44 24 04 d2 5b 00 	movl   $0x5bd2,0x4(%esp)
    286a:	00 
    286b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2872:	e8 3e 25 00 00       	call   4db5 <printf>
    2877:	e8 a0 23 00 00       	call   4c1c <exit>
    287c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    287f:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
    2884:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2888:	eb 01                	jmp    288b <concreate+0x20a>
    288a:	90                   	nop
    288b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    2892:	00 
    2893:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2896:	89 44 24 04          	mov    %eax,0x4(%esp)
    289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    289d:	89 04 24             	mov    %eax,(%esp)
    28a0:	e8 8f 23 00 00       	call   4c34 <read>
    28a5:	85 c0                	test   %eax,%eax
    28a7:	0f 8f 41 ff ff ff    	jg     27ee <concreate+0x16d>
    28ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28b0:	89 04 24             	mov    %eax,(%esp)
    28b3:	e8 8c 23 00 00       	call   4c44 <close>
    28b8:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    28bc:	74 19                	je     28d7 <concreate+0x256>
    28be:	c7 44 24 04 f0 5b 00 	movl   $0x5bf0,0x4(%esp)
    28c5:	00 
    28c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28cd:	e8 e3 24 00 00       	call   4db5 <printf>
    28d2:	e8 45 23 00 00       	call   4c1c <exit>
    28d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    28de:	e9 2d 01 00 00       	jmp    2a10 <concreate+0x38f>
    28e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    28e6:	83 c0 30             	add    $0x30,%eax
    28e9:	88 45 e6             	mov    %al,-0x1a(%ebp)
    28ec:	e8 23 23 00 00       	call   4c14 <fork>
    28f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    28f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28f8:	79 19                	jns    2913 <concreate+0x292>
    28fa:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    2901:	00 
    2902:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2909:	e8 a7 24 00 00       	call   4db5 <printf>
    290e:	e8 09 23 00 00       	call   4c1c <exit>
    2913:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    2916:	ba 56 55 55 55       	mov    $0x55555556,%edx
    291b:	89 c8                	mov    %ecx,%eax
    291d:	f7 ea                	imul   %edx
    291f:	89 c8                	mov    %ecx,%eax
    2921:	c1 f8 1f             	sar    $0x1f,%eax
    2924:	29 c2                	sub    %eax,%edx
    2926:	89 d0                	mov    %edx,%eax
    2928:	01 c0                	add    %eax,%eax
    292a:	01 d0                	add    %edx,%eax
    292c:	89 ca                	mov    %ecx,%edx
    292e:	29 c2                	sub    %eax,%edx
    2930:	85 d2                	test   %edx,%edx
    2932:	75 06                	jne    293a <concreate+0x2b9>
    2934:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2938:	74 28                	je     2962 <concreate+0x2e1>
    293a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    293d:	ba 56 55 55 55       	mov    $0x55555556,%edx
    2942:	89 c8                	mov    %ecx,%eax
    2944:	f7 ea                	imul   %edx
    2946:	89 c8                	mov    %ecx,%eax
    2948:	c1 f8 1f             	sar    $0x1f,%eax
    294b:	29 c2                	sub    %eax,%edx
    294d:	89 d0                	mov    %edx,%eax
    294f:	01 c0                	add    %eax,%eax
    2951:	01 d0                	add    %edx,%eax
    2953:	89 ca                	mov    %ecx,%edx
    2955:	29 c2                	sub    %eax,%edx
    2957:	83 fa 01             	cmp    $0x1,%edx
    295a:	75 74                	jne    29d0 <concreate+0x34f>
    295c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2960:	74 6e                	je     29d0 <concreate+0x34f>
    2962:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2969:	00 
    296a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    296d:	89 04 24             	mov    %eax,(%esp)
    2970:	e8 e7 22 00 00       	call   4c5c <open>
    2975:	89 04 24             	mov    %eax,(%esp)
    2978:	e8 c7 22 00 00       	call   4c44 <close>
    297d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2984:	00 
    2985:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2988:	89 04 24             	mov    %eax,(%esp)
    298b:	e8 cc 22 00 00       	call   4c5c <open>
    2990:	89 04 24             	mov    %eax,(%esp)
    2993:	e8 ac 22 00 00       	call   4c44 <close>
    2998:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    299f:	00 
    29a0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29a3:	89 04 24             	mov    %eax,(%esp)
    29a6:	e8 b1 22 00 00       	call   4c5c <open>
    29ab:	89 04 24             	mov    %eax,(%esp)
    29ae:	e8 91 22 00 00       	call   4c44 <close>
    29b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    29ba:	00 
    29bb:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29be:	89 04 24             	mov    %eax,(%esp)
    29c1:	e8 96 22 00 00       	call   4c5c <open>
    29c6:	89 04 24             	mov    %eax,(%esp)
    29c9:	e8 76 22 00 00       	call   4c44 <close>
    29ce:	eb 2c                	jmp    29fc <concreate+0x37b>
    29d0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29d3:	89 04 24             	mov    %eax,(%esp)
    29d6:	e8 91 22 00 00       	call   4c6c <unlink>
    29db:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29de:	89 04 24             	mov    %eax,(%esp)
    29e1:	e8 86 22 00 00       	call   4c6c <unlink>
    29e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29e9:	89 04 24             	mov    %eax,(%esp)
    29ec:	e8 7b 22 00 00       	call   4c6c <unlink>
    29f1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29f4:	89 04 24             	mov    %eax,(%esp)
    29f7:	e8 70 22 00 00       	call   4c6c <unlink>
    29fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a00:	75 05                	jne    2a07 <concreate+0x386>
    2a02:	e8 15 22 00 00       	call   4c1c <exit>
    2a07:	e8 18 22 00 00       	call   4c24 <wait>
    2a0c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    2a10:	83 7d e8 27          	cmpl   $0x27,-0x18(%ebp)
    2a14:	0f 8e c9 fe ff ff    	jle    28e3 <concreate+0x262>
    2a1a:	c7 44 24 04 21 5c 00 	movl   $0x5c21,0x4(%esp)
    2a21:	00 
    2a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a29:	e8 87 23 00 00       	call   4db5 <printf>
    2a2e:	c9                   	leave  
    2a2f:	c3                   	ret    

00002a30 <linkunlink>:
    2a30:	55                   	push   %ebp
    2a31:	89 e5                	mov    %esp,%ebp
    2a33:	83 ec 28             	sub    $0x28,%esp
    2a36:	c7 44 24 04 2f 5c 00 	movl   $0x5c2f,0x4(%esp)
    2a3d:	00 
    2a3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a45:	e8 6b 23 00 00       	call   4db5 <printf>
    2a4a:	c7 04 24 96 57 00 00 	movl   $0x5796,(%esp)
    2a51:	e8 16 22 00 00       	call   4c6c <unlink>
    2a56:	e8 b9 21 00 00       	call   4c14 <fork>
    2a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2a5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a62:	79 19                	jns    2a7d <linkunlink+0x4d>
    2a64:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    2a6b:	00 
    2a6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a73:	e8 3d 23 00 00       	call   4db5 <printf>
    2a78:	e8 9f 21 00 00       	call   4c1c <exit>
    2a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a81:	74 07                	je     2a8a <linkunlink+0x5a>
    2a83:	b8 01 00 00 00       	mov    $0x1,%eax
    2a88:	eb 05                	jmp    2a8f <linkunlink+0x5f>
    2a8a:	b8 61 00 00 00       	mov    $0x61,%eax
    2a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2a92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2a99:	e9 8e 00 00 00       	jmp    2b2c <linkunlink+0xfc>
    2a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2aa1:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    2aa7:	05 39 30 00 00       	add    $0x3039,%eax
    2aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2aaf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2ab2:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    2ab7:	89 c8                	mov    %ecx,%eax
    2ab9:	f7 e2                	mul    %edx
    2abb:	d1 ea                	shr    %edx
    2abd:	89 d0                	mov    %edx,%eax
    2abf:	01 c0                	add    %eax,%eax
    2ac1:	01 d0                	add    %edx,%eax
    2ac3:	89 ca                	mov    %ecx,%edx
    2ac5:	29 c2                	sub    %eax,%edx
    2ac7:	85 d2                	test   %edx,%edx
    2ac9:	75 1e                	jne    2ae9 <linkunlink+0xb9>
    2acb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2ad2:	00 
    2ad3:	c7 04 24 96 57 00 00 	movl   $0x5796,(%esp)
    2ada:	e8 7d 21 00 00       	call   4c5c <open>
    2adf:	89 04 24             	mov    %eax,(%esp)
    2ae2:	e8 5d 21 00 00       	call   4c44 <close>
    2ae7:	eb 3f                	jmp    2b28 <linkunlink+0xf8>
    2ae9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2aec:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    2af1:	89 c8                	mov    %ecx,%eax
    2af3:	f7 e2                	mul    %edx
    2af5:	d1 ea                	shr    %edx
    2af7:	89 d0                	mov    %edx,%eax
    2af9:	01 c0                	add    %eax,%eax
    2afb:	01 d0                	add    %edx,%eax
    2afd:	89 ca                	mov    %ecx,%edx
    2aff:	29 c2                	sub    %eax,%edx
    2b01:	83 fa 01             	cmp    $0x1,%edx
    2b04:	75 16                	jne    2b1c <linkunlink+0xec>
    2b06:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    2b0d:	00 
    2b0e:	c7 04 24 40 5c 00 00 	movl   $0x5c40,(%esp)
    2b15:	e8 62 21 00 00       	call   4c7c <link>
    2b1a:	eb 0c                	jmp    2b28 <linkunlink+0xf8>
    2b1c:	c7 04 24 96 57 00 00 	movl   $0x5796,(%esp)
    2b23:	e8 44 21 00 00       	call   4c6c <unlink>
    2b28:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2b2c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
    2b30:	0f 8e 68 ff ff ff    	jle    2a9e <linkunlink+0x6e>
    2b36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2b3a:	74 1b                	je     2b57 <linkunlink+0x127>
    2b3c:	e8 e3 20 00 00       	call   4c24 <wait>
    2b41:	c7 44 24 04 44 5c 00 	movl   $0x5c44,0x4(%esp)
    2b48:	00 
    2b49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b50:	e8 60 22 00 00       	call   4db5 <printf>
    2b55:	c9                   	leave  
    2b56:	c3                   	ret    
    2b57:	e8 c0 20 00 00       	call   4c1c <exit>

00002b5c <bigdir>:
    2b5c:	55                   	push   %ebp
    2b5d:	89 e5                	mov    %esp,%ebp
    2b5f:	83 ec 38             	sub    $0x38,%esp
    2b62:	c7 44 24 04 53 5c 00 	movl   $0x5c53,0x4(%esp)
    2b69:	00 
    2b6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b71:	e8 3f 22 00 00       	call   4db5 <printf>
    2b76:	c7 04 24 60 5c 00 00 	movl   $0x5c60,(%esp)
    2b7d:	e8 ea 20 00 00       	call   4c6c <unlink>
    2b82:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2b89:	00 
    2b8a:	c7 04 24 60 5c 00 00 	movl   $0x5c60,(%esp)
    2b91:	e8 c6 20 00 00       	call   4c5c <open>
    2b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2b9d:	79 19                	jns    2bb8 <bigdir+0x5c>
    2b9f:	c7 44 24 04 63 5c 00 	movl   $0x5c63,0x4(%esp)
    2ba6:	00 
    2ba7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bae:	e8 02 22 00 00       	call   4db5 <printf>
    2bb3:	e8 64 20 00 00       	call   4c1c <exit>
    2bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2bbb:	89 04 24             	mov    %eax,(%esp)
    2bbe:	e8 81 20 00 00       	call   4c44 <close>
    2bc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2bca:	eb 68                	jmp    2c34 <bigdir+0xd8>
    2bcc:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    2bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2bd3:	8d 50 3f             	lea    0x3f(%eax),%edx
    2bd6:	85 c0                	test   %eax,%eax
    2bd8:	0f 48 c2             	cmovs  %edx,%eax
    2bdb:	c1 f8 06             	sar    $0x6,%eax
    2bde:	83 c0 30             	add    $0x30,%eax
    2be1:	88 45 e7             	mov    %al,-0x19(%ebp)
    2be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2be7:	89 c2                	mov    %eax,%edx
    2be9:	c1 fa 1f             	sar    $0x1f,%edx
    2bec:	c1 ea 1a             	shr    $0x1a,%edx
    2bef:	01 d0                	add    %edx,%eax
    2bf1:	83 e0 3f             	and    $0x3f,%eax
    2bf4:	29 d0                	sub    %edx,%eax
    2bf6:	83 c0 30             	add    $0x30,%eax
    2bf9:	88 45 e8             	mov    %al,-0x18(%ebp)
    2bfc:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    2c00:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    2c03:	89 44 24 04          	mov    %eax,0x4(%esp)
    2c07:	c7 04 24 60 5c 00 00 	movl   $0x5c60,(%esp)
    2c0e:	e8 69 20 00 00       	call   4c7c <link>
    2c13:	85 c0                	test   %eax,%eax
    2c15:	74 19                	je     2c30 <bigdir+0xd4>
    2c17:	c7 44 24 04 79 5c 00 	movl   $0x5c79,0x4(%esp)
    2c1e:	00 
    2c1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c26:	e8 8a 21 00 00       	call   4db5 <printf>
    2c2b:	e8 ec 1f 00 00       	call   4c1c <exit>
    2c30:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2c34:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
    2c3b:	7e 8f                	jle    2bcc <bigdir+0x70>
    2c3d:	c7 04 24 60 5c 00 00 	movl   $0x5c60,(%esp)
    2c44:	e8 23 20 00 00       	call   4c6c <unlink>
    2c49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2c50:	eb 60                	jmp    2cb2 <bigdir+0x156>
    2c52:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    2c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2c59:	8d 50 3f             	lea    0x3f(%eax),%edx
    2c5c:	85 c0                	test   %eax,%eax
    2c5e:	0f 48 c2             	cmovs  %edx,%eax
    2c61:	c1 f8 06             	sar    $0x6,%eax
    2c64:	83 c0 30             	add    $0x30,%eax
    2c67:	88 45 e7             	mov    %al,-0x19(%ebp)
    2c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2c6d:	89 c2                	mov    %eax,%edx
    2c6f:	c1 fa 1f             	sar    $0x1f,%edx
    2c72:	c1 ea 1a             	shr    $0x1a,%edx
    2c75:	01 d0                	add    %edx,%eax
    2c77:	83 e0 3f             	and    $0x3f,%eax
    2c7a:	29 d0                	sub    %edx,%eax
    2c7c:	83 c0 30             	add    $0x30,%eax
    2c7f:	88 45 e8             	mov    %al,-0x18(%ebp)
    2c82:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    2c86:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    2c89:	89 04 24             	mov    %eax,(%esp)
    2c8c:	e8 db 1f 00 00       	call   4c6c <unlink>
    2c91:	85 c0                	test   %eax,%eax
    2c93:	74 19                	je     2cae <bigdir+0x152>
    2c95:	c7 44 24 04 8d 5c 00 	movl   $0x5c8d,0x4(%esp)
    2c9c:	00 
    2c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ca4:	e8 0c 21 00 00       	call   4db5 <printf>
    2ca9:	e8 6e 1f 00 00       	call   4c1c <exit>
    2cae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2cb2:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
    2cb9:	7e 97                	jle    2c52 <bigdir+0xf6>
    2cbb:	c7 44 24 04 a2 5c 00 	movl   $0x5ca2,0x4(%esp)
    2cc2:	00 
    2cc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cca:	e8 e6 20 00 00       	call   4db5 <printf>
    2ccf:	c9                   	leave  
    2cd0:	c3                   	ret    

00002cd1 <subdir>:
    2cd1:	55                   	push   %ebp
    2cd2:	89 e5                	mov    %esp,%ebp
    2cd4:	83 ec 28             	sub    $0x28,%esp
    2cd7:	c7 44 24 04 ad 5c 00 	movl   $0x5cad,0x4(%esp)
    2cde:	00 
    2cdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ce6:	e8 ca 20 00 00       	call   4db5 <printf>
    2ceb:	c7 04 24 ba 5c 00 00 	movl   $0x5cba,(%esp)
    2cf2:	e8 75 1f 00 00       	call   4c6c <unlink>
    2cf7:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    2cfe:	e8 81 1f 00 00       	call   4c84 <mkdir>
    2d03:	85 c0                	test   %eax,%eax
    2d05:	74 19                	je     2d20 <subdir+0x4f>
    2d07:	c7 44 24 04 c0 5c 00 	movl   $0x5cc0,0x4(%esp)
    2d0e:	00 
    2d0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d16:	e8 9a 20 00 00       	call   4db5 <printf>
    2d1b:	e8 fc 1e 00 00       	call   4c1c <exit>
    2d20:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2d27:	00 
    2d28:	c7 04 24 d8 5c 00 00 	movl   $0x5cd8,(%esp)
    2d2f:	e8 28 1f 00 00       	call   4c5c <open>
    2d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d3b:	79 19                	jns    2d56 <subdir+0x85>
    2d3d:	c7 44 24 04 de 5c 00 	movl   $0x5cde,0x4(%esp)
    2d44:	00 
    2d45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d4c:	e8 64 20 00 00       	call   4db5 <printf>
    2d51:	e8 c6 1e 00 00       	call   4c1c <exit>
    2d56:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2d5d:	00 
    2d5e:	c7 44 24 04 ba 5c 00 	movl   $0x5cba,0x4(%esp)
    2d65:	00 
    2d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d69:	89 04 24             	mov    %eax,(%esp)
    2d6c:	e8 cb 1e 00 00       	call   4c3c <write>
    2d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d74:	89 04 24             	mov    %eax,(%esp)
    2d77:	e8 c8 1e 00 00       	call   4c44 <close>
    2d7c:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    2d83:	e8 e4 1e 00 00       	call   4c6c <unlink>
    2d88:	85 c0                	test   %eax,%eax
    2d8a:	78 19                	js     2da5 <subdir+0xd4>
    2d8c:	c7 44 24 04 f4 5c 00 	movl   $0x5cf4,0x4(%esp)
    2d93:	00 
    2d94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d9b:	e8 15 20 00 00       	call   4db5 <printf>
    2da0:	e8 77 1e 00 00       	call   4c1c <exit>
    2da5:	c7 04 24 1a 5d 00 00 	movl   $0x5d1a,(%esp)
    2dac:	e8 d3 1e 00 00       	call   4c84 <mkdir>
    2db1:	85 c0                	test   %eax,%eax
    2db3:	74 19                	je     2dce <subdir+0xfd>
    2db5:	c7 44 24 04 21 5d 00 	movl   $0x5d21,0x4(%esp)
    2dbc:	00 
    2dbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dc4:	e8 ec 1f 00 00       	call   4db5 <printf>
    2dc9:	e8 4e 1e 00 00       	call   4c1c <exit>
    2dce:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2dd5:	00 
    2dd6:	c7 04 24 3c 5d 00 00 	movl   $0x5d3c,(%esp)
    2ddd:	e8 7a 1e 00 00       	call   4c5c <open>
    2de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2de5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2de9:	79 19                	jns    2e04 <subdir+0x133>
    2deb:	c7 44 24 04 45 5d 00 	movl   $0x5d45,0x4(%esp)
    2df2:	00 
    2df3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dfa:	e8 b6 1f 00 00       	call   4db5 <printf>
    2dff:	e8 18 1e 00 00       	call   4c1c <exit>
    2e04:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2e0b:	00 
    2e0c:	c7 44 24 04 5d 5d 00 	movl   $0x5d5d,0x4(%esp)
    2e13:	00 
    2e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2e17:	89 04 24             	mov    %eax,(%esp)
    2e1a:	e8 1d 1e 00 00       	call   4c3c <write>
    2e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2e22:	89 04 24             	mov    %eax,(%esp)
    2e25:	e8 1a 1e 00 00       	call   4c44 <close>
    2e2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e31:	00 
    2e32:	c7 04 24 60 5d 00 00 	movl   $0x5d60,(%esp)
    2e39:	e8 1e 1e 00 00       	call   4c5c <open>
    2e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2e45:	79 19                	jns    2e60 <subdir+0x18f>
    2e47:	c7 44 24 04 6c 5d 00 	movl   $0x5d6c,0x4(%esp)
    2e4e:	00 
    2e4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e56:	e8 5a 1f 00 00       	call   4db5 <printf>
    2e5b:	e8 bc 1d 00 00       	call   4c1c <exit>
    2e60:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2e67:	00 
    2e68:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    2e6f:	00 
    2e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2e73:	89 04 24             	mov    %eax,(%esp)
    2e76:	e8 b9 1d 00 00       	call   4c34 <read>
    2e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2e7e:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
    2e82:	75 0b                	jne    2e8f <subdir+0x1be>
    2e84:	0f b6 05 e0 92 00 00 	movzbl 0x92e0,%eax
    2e8b:	3c 66                	cmp    $0x66,%al
    2e8d:	74 19                	je     2ea8 <subdir+0x1d7>
    2e8f:	c7 44 24 04 85 5d 00 	movl   $0x5d85,0x4(%esp)
    2e96:	00 
    2e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e9e:	e8 12 1f 00 00       	call   4db5 <printf>
    2ea3:	e8 74 1d 00 00       	call   4c1c <exit>
    2ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2eab:	89 04 24             	mov    %eax,(%esp)
    2eae:	e8 91 1d 00 00       	call   4c44 <close>
    2eb3:	c7 44 24 04 a0 5d 00 	movl   $0x5da0,0x4(%esp)
    2eba:	00 
    2ebb:	c7 04 24 3c 5d 00 00 	movl   $0x5d3c,(%esp)
    2ec2:	e8 b5 1d 00 00       	call   4c7c <link>
    2ec7:	85 c0                	test   %eax,%eax
    2ec9:	74 19                	je     2ee4 <subdir+0x213>
    2ecb:	c7 44 24 04 ac 5d 00 	movl   $0x5dac,0x4(%esp)
    2ed2:	00 
    2ed3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2eda:	e8 d6 1e 00 00       	call   4db5 <printf>
    2edf:	e8 38 1d 00 00       	call   4c1c <exit>
    2ee4:	c7 04 24 3c 5d 00 00 	movl   $0x5d3c,(%esp)
    2eeb:	e8 7c 1d 00 00       	call   4c6c <unlink>
    2ef0:	85 c0                	test   %eax,%eax
    2ef2:	74 19                	je     2f0d <subdir+0x23c>
    2ef4:	c7 44 24 04 cd 5d 00 	movl   $0x5dcd,0x4(%esp)
    2efb:	00 
    2efc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f03:	e8 ad 1e 00 00       	call   4db5 <printf>
    2f08:	e8 0f 1d 00 00       	call   4c1c <exit>
    2f0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2f14:	00 
    2f15:	c7 04 24 3c 5d 00 00 	movl   $0x5d3c,(%esp)
    2f1c:	e8 3b 1d 00 00       	call   4c5c <open>
    2f21:	85 c0                	test   %eax,%eax
    2f23:	78 19                	js     2f3e <subdir+0x26d>
    2f25:	c7 44 24 04 e8 5d 00 	movl   $0x5de8,0x4(%esp)
    2f2c:	00 
    2f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f34:	e8 7c 1e 00 00       	call   4db5 <printf>
    2f39:	e8 de 1c 00 00       	call   4c1c <exit>
    2f3e:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    2f45:	e8 42 1d 00 00       	call   4c8c <chdir>
    2f4a:	85 c0                	test   %eax,%eax
    2f4c:	74 19                	je     2f67 <subdir+0x296>
    2f4e:	c7 44 24 04 0c 5e 00 	movl   $0x5e0c,0x4(%esp)
    2f55:	00 
    2f56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f5d:	e8 53 1e 00 00       	call   4db5 <printf>
    2f62:	e8 b5 1c 00 00       	call   4c1c <exit>
    2f67:	c7 04 24 1d 5e 00 00 	movl   $0x5e1d,(%esp)
    2f6e:	e8 19 1d 00 00       	call   4c8c <chdir>
    2f73:	85 c0                	test   %eax,%eax
    2f75:	74 19                	je     2f90 <subdir+0x2bf>
    2f77:	c7 44 24 04 29 5e 00 	movl   $0x5e29,0x4(%esp)
    2f7e:	00 
    2f7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f86:	e8 2a 1e 00 00       	call   4db5 <printf>
    2f8b:	e8 8c 1c 00 00       	call   4c1c <exit>
    2f90:	c7 04 24 43 5e 00 00 	movl   $0x5e43,(%esp)
    2f97:	e8 f0 1c 00 00       	call   4c8c <chdir>
    2f9c:	85 c0                	test   %eax,%eax
    2f9e:	74 19                	je     2fb9 <subdir+0x2e8>
    2fa0:	c7 44 24 04 29 5e 00 	movl   $0x5e29,0x4(%esp)
    2fa7:	00 
    2fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2faf:	e8 01 1e 00 00       	call   4db5 <printf>
    2fb4:	e8 63 1c 00 00       	call   4c1c <exit>
    2fb9:	c7 04 24 52 5e 00 00 	movl   $0x5e52,(%esp)
    2fc0:	e8 c7 1c 00 00       	call   4c8c <chdir>
    2fc5:	85 c0                	test   %eax,%eax
    2fc7:	74 19                	je     2fe2 <subdir+0x311>
    2fc9:	c7 44 24 04 57 5e 00 	movl   $0x5e57,0x4(%esp)
    2fd0:	00 
    2fd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fd8:	e8 d8 1d 00 00       	call   4db5 <printf>
    2fdd:	e8 3a 1c 00 00       	call   4c1c <exit>
    2fe2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2fe9:	00 
    2fea:	c7 04 24 a0 5d 00 00 	movl   $0x5da0,(%esp)
    2ff1:	e8 66 1c 00 00       	call   4c5c <open>
    2ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2ff9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2ffd:	79 19                	jns    3018 <subdir+0x347>
    2fff:	c7 44 24 04 6a 5e 00 	movl   $0x5e6a,0x4(%esp)
    3006:	00 
    3007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    300e:	e8 a2 1d 00 00       	call   4db5 <printf>
    3013:	e8 04 1c 00 00       	call   4c1c <exit>
    3018:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    301f:	00 
    3020:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    3027:	00 
    3028:	8b 45 f0             	mov    -0x10(%ebp),%eax
    302b:	89 04 24             	mov    %eax,(%esp)
    302e:	e8 01 1c 00 00       	call   4c34 <read>
    3033:	83 f8 02             	cmp    $0x2,%eax
    3036:	74 19                	je     3051 <subdir+0x380>
    3038:	c7 44 24 04 82 5e 00 	movl   $0x5e82,0x4(%esp)
    303f:	00 
    3040:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3047:	e8 69 1d 00 00       	call   4db5 <printf>
    304c:	e8 cb 1b 00 00       	call   4c1c <exit>
    3051:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3054:	89 04 24             	mov    %eax,(%esp)
    3057:	e8 e8 1b 00 00       	call   4c44 <close>
    305c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3063:	00 
    3064:	c7 04 24 3c 5d 00 00 	movl   $0x5d3c,(%esp)
    306b:	e8 ec 1b 00 00       	call   4c5c <open>
    3070:	85 c0                	test   %eax,%eax
    3072:	78 19                	js     308d <subdir+0x3bc>
    3074:	c7 44 24 04 a0 5e 00 	movl   $0x5ea0,0x4(%esp)
    307b:	00 
    307c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3083:	e8 2d 1d 00 00       	call   4db5 <printf>
    3088:	e8 8f 1b 00 00       	call   4c1c <exit>
    308d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3094:	00 
    3095:	c7 04 24 c5 5e 00 00 	movl   $0x5ec5,(%esp)
    309c:	e8 bb 1b 00 00       	call   4c5c <open>
    30a1:	85 c0                	test   %eax,%eax
    30a3:	78 19                	js     30be <subdir+0x3ed>
    30a5:	c7 44 24 04 ce 5e 00 	movl   $0x5ece,0x4(%esp)
    30ac:	00 
    30ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30b4:	e8 fc 1c 00 00       	call   4db5 <printf>
    30b9:	e8 5e 1b 00 00       	call   4c1c <exit>
    30be:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    30c5:	00 
    30c6:	c7 04 24 ea 5e 00 00 	movl   $0x5eea,(%esp)
    30cd:	e8 8a 1b 00 00       	call   4c5c <open>
    30d2:	85 c0                	test   %eax,%eax
    30d4:	78 19                	js     30ef <subdir+0x41e>
    30d6:	c7 44 24 04 f3 5e 00 	movl   $0x5ef3,0x4(%esp)
    30dd:	00 
    30de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30e5:	e8 cb 1c 00 00       	call   4db5 <printf>
    30ea:	e8 2d 1b 00 00       	call   4c1c <exit>
    30ef:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    30f6:	00 
    30f7:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    30fe:	e8 59 1b 00 00       	call   4c5c <open>
    3103:	85 c0                	test   %eax,%eax
    3105:	78 19                	js     3120 <subdir+0x44f>
    3107:	c7 44 24 04 0f 5f 00 	movl   $0x5f0f,0x4(%esp)
    310e:	00 
    310f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3116:	e8 9a 1c 00 00       	call   4db5 <printf>
    311b:	e8 fc 1a 00 00       	call   4c1c <exit>
    3120:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    3127:	00 
    3128:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    312f:	e8 28 1b 00 00       	call   4c5c <open>
    3134:	85 c0                	test   %eax,%eax
    3136:	78 19                	js     3151 <subdir+0x480>
    3138:	c7 44 24 04 25 5f 00 	movl   $0x5f25,0x4(%esp)
    313f:	00 
    3140:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3147:	e8 69 1c 00 00       	call   4db5 <printf>
    314c:	e8 cb 1a 00 00       	call   4c1c <exit>
    3151:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    3158:	00 
    3159:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    3160:	e8 f7 1a 00 00       	call   4c5c <open>
    3165:	85 c0                	test   %eax,%eax
    3167:	78 19                	js     3182 <subdir+0x4b1>
    3169:	c7 44 24 04 3e 5f 00 	movl   $0x5f3e,0x4(%esp)
    3170:	00 
    3171:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3178:	e8 38 1c 00 00       	call   4db5 <printf>
    317d:	e8 9a 1a 00 00       	call   4c1c <exit>
    3182:	c7 44 24 04 59 5f 00 	movl   $0x5f59,0x4(%esp)
    3189:	00 
    318a:	c7 04 24 c5 5e 00 00 	movl   $0x5ec5,(%esp)
    3191:	e8 e6 1a 00 00       	call   4c7c <link>
    3196:	85 c0                	test   %eax,%eax
    3198:	75 19                	jne    31b3 <subdir+0x4e2>
    319a:	c7 44 24 04 64 5f 00 	movl   $0x5f64,0x4(%esp)
    31a1:	00 
    31a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31a9:	e8 07 1c 00 00       	call   4db5 <printf>
    31ae:	e8 69 1a 00 00       	call   4c1c <exit>
    31b3:	c7 44 24 04 59 5f 00 	movl   $0x5f59,0x4(%esp)
    31ba:	00 
    31bb:	c7 04 24 ea 5e 00 00 	movl   $0x5eea,(%esp)
    31c2:	e8 b5 1a 00 00       	call   4c7c <link>
    31c7:	85 c0                	test   %eax,%eax
    31c9:	75 19                	jne    31e4 <subdir+0x513>
    31cb:	c7 44 24 04 88 5f 00 	movl   $0x5f88,0x4(%esp)
    31d2:	00 
    31d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31da:	e8 d6 1b 00 00       	call   4db5 <printf>
    31df:	e8 38 1a 00 00       	call   4c1c <exit>
    31e4:	c7 44 24 04 a0 5d 00 	movl   $0x5da0,0x4(%esp)
    31eb:	00 
    31ec:	c7 04 24 d8 5c 00 00 	movl   $0x5cd8,(%esp)
    31f3:	e8 84 1a 00 00       	call   4c7c <link>
    31f8:	85 c0                	test   %eax,%eax
    31fa:	75 19                	jne    3215 <subdir+0x544>
    31fc:	c7 44 24 04 ac 5f 00 	movl   $0x5fac,0x4(%esp)
    3203:	00 
    3204:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    320b:	e8 a5 1b 00 00       	call   4db5 <printf>
    3210:	e8 07 1a 00 00       	call   4c1c <exit>
    3215:	c7 04 24 c5 5e 00 00 	movl   $0x5ec5,(%esp)
    321c:	e8 63 1a 00 00       	call   4c84 <mkdir>
    3221:	85 c0                	test   %eax,%eax
    3223:	75 19                	jne    323e <subdir+0x56d>
    3225:	c7 44 24 04 ce 5f 00 	movl   $0x5fce,0x4(%esp)
    322c:	00 
    322d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3234:	e8 7c 1b 00 00       	call   4db5 <printf>
    3239:	e8 de 19 00 00       	call   4c1c <exit>
    323e:	c7 04 24 ea 5e 00 00 	movl   $0x5eea,(%esp)
    3245:	e8 3a 1a 00 00       	call   4c84 <mkdir>
    324a:	85 c0                	test   %eax,%eax
    324c:	75 19                	jne    3267 <subdir+0x596>
    324e:	c7 44 24 04 e9 5f 00 	movl   $0x5fe9,0x4(%esp)
    3255:	00 
    3256:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    325d:	e8 53 1b 00 00       	call   4db5 <printf>
    3262:	e8 b5 19 00 00       	call   4c1c <exit>
    3267:	c7 04 24 a0 5d 00 00 	movl   $0x5da0,(%esp)
    326e:	e8 11 1a 00 00       	call   4c84 <mkdir>
    3273:	85 c0                	test   %eax,%eax
    3275:	75 19                	jne    3290 <subdir+0x5bf>
    3277:	c7 44 24 04 04 60 00 	movl   $0x6004,0x4(%esp)
    327e:	00 
    327f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3286:	e8 2a 1b 00 00       	call   4db5 <printf>
    328b:	e8 8c 19 00 00       	call   4c1c <exit>
    3290:	c7 04 24 ea 5e 00 00 	movl   $0x5eea,(%esp)
    3297:	e8 d0 19 00 00       	call   4c6c <unlink>
    329c:	85 c0                	test   %eax,%eax
    329e:	75 19                	jne    32b9 <subdir+0x5e8>
    32a0:	c7 44 24 04 21 60 00 	movl   $0x6021,0x4(%esp)
    32a7:	00 
    32a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32af:	e8 01 1b 00 00       	call   4db5 <printf>
    32b4:	e8 63 19 00 00       	call   4c1c <exit>
    32b9:	c7 04 24 c5 5e 00 00 	movl   $0x5ec5,(%esp)
    32c0:	e8 a7 19 00 00       	call   4c6c <unlink>
    32c5:	85 c0                	test   %eax,%eax
    32c7:	75 19                	jne    32e2 <subdir+0x611>
    32c9:	c7 44 24 04 3d 60 00 	movl   $0x603d,0x4(%esp)
    32d0:	00 
    32d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32d8:	e8 d8 1a 00 00       	call   4db5 <printf>
    32dd:	e8 3a 19 00 00       	call   4c1c <exit>
    32e2:	c7 04 24 d8 5c 00 00 	movl   $0x5cd8,(%esp)
    32e9:	e8 9e 19 00 00       	call   4c8c <chdir>
    32ee:	85 c0                	test   %eax,%eax
    32f0:	75 19                	jne    330b <subdir+0x63a>
    32f2:	c7 44 24 04 59 60 00 	movl   $0x6059,0x4(%esp)
    32f9:	00 
    32fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3301:	e8 af 1a 00 00       	call   4db5 <printf>
    3306:	e8 11 19 00 00       	call   4c1c <exit>
    330b:	c7 04 24 71 60 00 00 	movl   $0x6071,(%esp)
    3312:	e8 75 19 00 00       	call   4c8c <chdir>
    3317:	85 c0                	test   %eax,%eax
    3319:	75 19                	jne    3334 <subdir+0x663>
    331b:	c7 44 24 04 77 60 00 	movl   $0x6077,0x4(%esp)
    3322:	00 
    3323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    332a:	e8 86 1a 00 00       	call   4db5 <printf>
    332f:	e8 e8 18 00 00       	call   4c1c <exit>
    3334:	c7 04 24 a0 5d 00 00 	movl   $0x5da0,(%esp)
    333b:	e8 2c 19 00 00       	call   4c6c <unlink>
    3340:	85 c0                	test   %eax,%eax
    3342:	74 19                	je     335d <subdir+0x68c>
    3344:	c7 44 24 04 cd 5d 00 	movl   $0x5dcd,0x4(%esp)
    334b:	00 
    334c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3353:	e8 5d 1a 00 00       	call   4db5 <printf>
    3358:	e8 bf 18 00 00       	call   4c1c <exit>
    335d:	c7 04 24 d8 5c 00 00 	movl   $0x5cd8,(%esp)
    3364:	e8 03 19 00 00       	call   4c6c <unlink>
    3369:	85 c0                	test   %eax,%eax
    336b:	74 19                	je     3386 <subdir+0x6b5>
    336d:	c7 44 24 04 8f 60 00 	movl   $0x608f,0x4(%esp)
    3374:	00 
    3375:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    337c:	e8 34 1a 00 00       	call   4db5 <printf>
    3381:	e8 96 18 00 00       	call   4c1c <exit>
    3386:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    338d:	e8 da 18 00 00       	call   4c6c <unlink>
    3392:	85 c0                	test   %eax,%eax
    3394:	75 19                	jne    33af <subdir+0x6de>
    3396:	c7 44 24 04 a4 60 00 	movl   $0x60a4,0x4(%esp)
    339d:	00 
    339e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33a5:	e8 0b 1a 00 00       	call   4db5 <printf>
    33aa:	e8 6d 18 00 00       	call   4c1c <exit>
    33af:	c7 04 24 c4 60 00 00 	movl   $0x60c4,(%esp)
    33b6:	e8 b1 18 00 00       	call   4c6c <unlink>
    33bb:	85 c0                	test   %eax,%eax
    33bd:	79 19                	jns    33d8 <subdir+0x707>
    33bf:	c7 44 24 04 ca 60 00 	movl   $0x60ca,0x4(%esp)
    33c6:	00 
    33c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33ce:	e8 e2 19 00 00       	call   4db5 <printf>
    33d3:	e8 44 18 00 00       	call   4c1c <exit>
    33d8:	c7 04 24 bd 5c 00 00 	movl   $0x5cbd,(%esp)
    33df:	e8 88 18 00 00       	call   4c6c <unlink>
    33e4:	85 c0                	test   %eax,%eax
    33e6:	79 19                	jns    3401 <subdir+0x730>
    33e8:	c7 44 24 04 df 60 00 	movl   $0x60df,0x4(%esp)
    33ef:	00 
    33f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33f7:	e8 b9 19 00 00       	call   4db5 <printf>
    33fc:	e8 1b 18 00 00       	call   4c1c <exit>
    3401:	c7 44 24 04 f1 60 00 	movl   $0x60f1,0x4(%esp)
    3408:	00 
    3409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3410:	e8 a0 19 00 00       	call   4db5 <printf>
    3415:	c9                   	leave  
    3416:	c3                   	ret    

00003417 <bigwrite>:
    3417:	55                   	push   %ebp
    3418:	89 e5                	mov    %esp,%ebp
    341a:	83 ec 28             	sub    $0x28,%esp
    341d:	c7 44 24 04 fc 60 00 	movl   $0x60fc,0x4(%esp)
    3424:	00 
    3425:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    342c:	e8 84 19 00 00       	call   4db5 <printf>
    3431:	c7 04 24 0b 61 00 00 	movl   $0x610b,(%esp)
    3438:	e8 2f 18 00 00       	call   4c6c <unlink>
    343d:	c7 45 ec f3 01 00 00 	movl   $0x1f3,-0x14(%ebp)
    3444:	e9 b3 00 00 00       	jmp    34fc <bigwrite+0xe5>
    3449:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3450:	00 
    3451:	c7 04 24 0b 61 00 00 	movl   $0x610b,(%esp)
    3458:	e8 ff 17 00 00       	call   4c5c <open>
    345d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    3460:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3464:	79 19                	jns    347f <bigwrite+0x68>
    3466:	c7 44 24 04 14 61 00 	movl   $0x6114,0x4(%esp)
    346d:	00 
    346e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3475:	e8 3b 19 00 00       	call   4db5 <printf>
    347a:	e8 9d 17 00 00       	call   4c1c <exit>
    347f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3486:	eb 50                	jmp    34d8 <bigwrite+0xc1>
    3488:	8b 45 ec             	mov    -0x14(%ebp),%eax
    348b:	89 44 24 08          	mov    %eax,0x8(%esp)
    348f:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    3496:	00 
    3497:	8b 45 e8             	mov    -0x18(%ebp),%eax
    349a:	89 04 24             	mov    %eax,(%esp)
    349d:	e8 9a 17 00 00       	call   4c3c <write>
    34a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    34a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    34ab:	74 27                	je     34d4 <bigwrite+0xbd>
    34ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
    34b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    34b7:	89 44 24 08          	mov    %eax,0x8(%esp)
    34bb:	c7 44 24 04 2c 61 00 	movl   $0x612c,0x4(%esp)
    34c2:	00 
    34c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34ca:	e8 e6 18 00 00       	call   4db5 <printf>
    34cf:	e8 48 17 00 00       	call   4c1c <exit>
    34d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    34d8:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    34dc:	7e aa                	jle    3488 <bigwrite+0x71>
    34de:	8b 45 e8             	mov    -0x18(%ebp),%eax
    34e1:	89 04 24             	mov    %eax,(%esp)
    34e4:	e8 5b 17 00 00       	call   4c44 <close>
    34e9:	c7 04 24 0b 61 00 00 	movl   $0x610b,(%esp)
    34f0:	e8 77 17 00 00       	call   4c6c <unlink>
    34f5:	81 45 ec d7 01 00 00 	addl   $0x1d7,-0x14(%ebp)
    34fc:	81 7d ec ff 17 00 00 	cmpl   $0x17ff,-0x14(%ebp)
    3503:	0f 8e 40 ff ff ff    	jle    3449 <bigwrite+0x32>
    3509:	c7 44 24 04 3e 61 00 	movl   $0x613e,0x4(%esp)
    3510:	00 
    3511:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3518:	e8 98 18 00 00       	call   4db5 <printf>
    351d:	c9                   	leave  
    351e:	c3                   	ret    

0000351f <bigfile>:
    351f:	55                   	push   %ebp
    3520:	89 e5                	mov    %esp,%ebp
    3522:	83 ec 28             	sub    $0x28,%esp
    3525:	c7 44 24 04 4b 61 00 	movl   $0x614b,0x4(%esp)
    352c:	00 
    352d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3534:	e8 7c 18 00 00       	call   4db5 <printf>
    3539:	c7 04 24 59 61 00 00 	movl   $0x6159,(%esp)
    3540:	e8 27 17 00 00       	call   4c6c <unlink>
    3545:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    354c:	00 
    354d:	c7 04 24 59 61 00 00 	movl   $0x6159,(%esp)
    3554:	e8 03 17 00 00       	call   4c5c <open>
    3559:	89 45 e8             	mov    %eax,-0x18(%ebp)
    355c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3560:	79 19                	jns    357b <bigfile+0x5c>
    3562:	c7 44 24 04 61 61 00 	movl   $0x6161,0x4(%esp)
    3569:	00 
    356a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3571:	e8 3f 18 00 00       	call   4db5 <printf>
    3576:	e8 a1 16 00 00       	call   4c1c <exit>
    357b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    3582:	eb 5a                	jmp    35de <bigfile+0xbf>
    3584:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    358b:	00 
    358c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    358f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3593:	c7 04 24 e0 92 00 00 	movl   $0x92e0,(%esp)
    359a:	e8 d7 14 00 00       	call   4a76 <memset>
    359f:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    35a6:	00 
    35a7:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    35ae:	00 
    35af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    35b2:	89 04 24             	mov    %eax,(%esp)
    35b5:	e8 82 16 00 00       	call   4c3c <write>
    35ba:	3d 58 02 00 00       	cmp    $0x258,%eax
    35bf:	74 19                	je     35da <bigfile+0xbb>
    35c1:	c7 44 24 04 77 61 00 	movl   $0x6177,0x4(%esp)
    35c8:	00 
    35c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35d0:	e8 e0 17 00 00       	call   4db5 <printf>
    35d5:	e8 42 16 00 00       	call   4c1c <exit>
    35da:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    35de:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
    35e2:	7e a0                	jle    3584 <bigfile+0x65>
    35e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    35e7:	89 04 24             	mov    %eax,(%esp)
    35ea:	e8 55 16 00 00       	call   4c44 <close>
    35ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    35f6:	00 
    35f7:	c7 04 24 59 61 00 00 	movl   $0x6159,(%esp)
    35fe:	e8 59 16 00 00       	call   4c5c <open>
    3603:	89 45 e8             	mov    %eax,-0x18(%ebp)
    3606:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    360a:	79 19                	jns    3625 <bigfile+0x106>
    360c:	c7 44 24 04 8d 61 00 	movl   $0x618d,0x4(%esp)
    3613:	00 
    3614:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    361b:	e8 95 17 00 00       	call   4db5 <printf>
    3620:	e8 f7 15 00 00       	call   4c1c <exit>
    3625:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    362c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    3633:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    363a:	00 
    363b:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    3642:	00 
    3643:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3646:	89 04 24             	mov    %eax,(%esp)
    3649:	e8 e6 15 00 00       	call   4c34 <read>
    364e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3655:	79 19                	jns    3670 <bigfile+0x151>
    3657:	c7 44 24 04 a2 61 00 	movl   $0x61a2,0x4(%esp)
    365e:	00 
    365f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3666:	e8 4a 17 00 00       	call   4db5 <printf>
    366b:	e8 ac 15 00 00       	call   4c1c <exit>
    3670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3674:	0f 84 80 00 00 00    	je     36fa <bigfile+0x1db>
    367a:	81 7d f4 2c 01 00 00 	cmpl   $0x12c,-0xc(%ebp)
    3681:	74 19                	je     369c <bigfile+0x17d>
    3683:	c7 44 24 04 b7 61 00 	movl   $0x61b7,0x4(%esp)
    368a:	00 
    368b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3692:	e8 1e 17 00 00       	call   4db5 <printf>
    3697:	e8 80 15 00 00       	call   4c1c <exit>
    369c:	0f b6 05 e0 92 00 00 	movzbl 0x92e0,%eax
    36a3:	0f be d0             	movsbl %al,%edx
    36a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    36a9:	89 c1                	mov    %eax,%ecx
    36ab:	c1 e9 1f             	shr    $0x1f,%ecx
    36ae:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    36b1:	d1 f8                	sar    %eax
    36b3:	39 c2                	cmp    %eax,%edx
    36b5:	75 1b                	jne    36d2 <bigfile+0x1b3>
    36b7:	0f b6 05 0b 94 00 00 	movzbl 0x940b,%eax
    36be:	0f be d0             	movsbl %al,%edx
    36c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    36c4:	89 c1                	mov    %eax,%ecx
    36c6:	c1 e9 1f             	shr    $0x1f,%ecx
    36c9:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    36cc:	d1 f8                	sar    %eax
    36ce:	39 c2                	cmp    %eax,%edx
    36d0:	74 19                	je     36eb <bigfile+0x1cc>
    36d2:	c7 44 24 04 cb 61 00 	movl   $0x61cb,0x4(%esp)
    36d9:	00 
    36da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36e1:	e8 cf 16 00 00       	call   4db5 <printf>
    36e6:	e8 31 15 00 00       	call   4c1c <exit>
    36eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36ee:	01 45 f0             	add    %eax,-0x10(%ebp)
    36f1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    36f5:	e9 39 ff ff ff       	jmp    3633 <bigfile+0x114>
    36fa:	90                   	nop
    36fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    36fe:	89 04 24             	mov    %eax,(%esp)
    3701:	e8 3e 15 00 00       	call   4c44 <close>
    3706:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    370d:	74 19                	je     3728 <bigfile+0x209>
    370f:	c7 44 24 04 e4 61 00 	movl   $0x61e4,0x4(%esp)
    3716:	00 
    3717:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    371e:	e8 92 16 00 00       	call   4db5 <printf>
    3723:	e8 f4 14 00 00       	call   4c1c <exit>
    3728:	c7 04 24 59 61 00 00 	movl   $0x6159,(%esp)
    372f:	e8 38 15 00 00       	call   4c6c <unlink>
    3734:	c7 44 24 04 fe 61 00 	movl   $0x61fe,0x4(%esp)
    373b:	00 
    373c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3743:	e8 6d 16 00 00       	call   4db5 <printf>
    3748:	c9                   	leave  
    3749:	c3                   	ret    

0000374a <fourteen>:
    374a:	55                   	push   %ebp
    374b:	89 e5                	mov    %esp,%ebp
    374d:	83 ec 28             	sub    $0x28,%esp
    3750:	c7 44 24 04 0f 62 00 	movl   $0x620f,0x4(%esp)
    3757:	00 
    3758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    375f:	e8 51 16 00 00       	call   4db5 <printf>
    3764:	c7 04 24 1e 62 00 00 	movl   $0x621e,(%esp)
    376b:	e8 14 15 00 00       	call   4c84 <mkdir>
    3770:	85 c0                	test   %eax,%eax
    3772:	74 19                	je     378d <fourteen+0x43>
    3774:	c7 44 24 04 2d 62 00 	movl   $0x622d,0x4(%esp)
    377b:	00 
    377c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3783:	e8 2d 16 00 00       	call   4db5 <printf>
    3788:	e8 8f 14 00 00       	call   4c1c <exit>
    378d:	c7 04 24 4c 62 00 00 	movl   $0x624c,(%esp)
    3794:	e8 eb 14 00 00       	call   4c84 <mkdir>
    3799:	85 c0                	test   %eax,%eax
    379b:	74 19                	je     37b6 <fourteen+0x6c>
    379d:	c7 44 24 04 6c 62 00 	movl   $0x626c,0x4(%esp)
    37a4:	00 
    37a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37ac:	e8 04 16 00 00       	call   4db5 <printf>
    37b1:	e8 66 14 00 00       	call   4c1c <exit>
    37b6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    37bd:	00 
    37be:	c7 04 24 9c 62 00 00 	movl   $0x629c,(%esp)
    37c5:	e8 92 14 00 00       	call   4c5c <open>
    37ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    37cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    37d1:	79 19                	jns    37ec <fourteen+0xa2>
    37d3:	c7 44 24 04 cc 62 00 	movl   $0x62cc,0x4(%esp)
    37da:	00 
    37db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37e2:	e8 ce 15 00 00       	call   4db5 <printf>
    37e7:	e8 30 14 00 00       	call   4c1c <exit>
    37ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37ef:	89 04 24             	mov    %eax,(%esp)
    37f2:	e8 4d 14 00 00       	call   4c44 <close>
    37f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    37fe:	00 
    37ff:	c7 04 24 0c 63 00 00 	movl   $0x630c,(%esp)
    3806:	e8 51 14 00 00       	call   4c5c <open>
    380b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    380e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3812:	79 19                	jns    382d <fourteen+0xe3>
    3814:	c7 44 24 04 3c 63 00 	movl   $0x633c,0x4(%esp)
    381b:	00 
    381c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3823:	e8 8d 15 00 00       	call   4db5 <printf>
    3828:	e8 ef 13 00 00       	call   4c1c <exit>
    382d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3830:	89 04 24             	mov    %eax,(%esp)
    3833:	e8 0c 14 00 00       	call   4c44 <close>
    3838:	c7 04 24 76 63 00 00 	movl   $0x6376,(%esp)
    383f:	e8 40 14 00 00       	call   4c84 <mkdir>
    3844:	85 c0                	test   %eax,%eax
    3846:	75 19                	jne    3861 <fourteen+0x117>
    3848:	c7 44 24 04 94 63 00 	movl   $0x6394,0x4(%esp)
    384f:	00 
    3850:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3857:	e8 59 15 00 00       	call   4db5 <printf>
    385c:	e8 bb 13 00 00       	call   4c1c <exit>
    3861:	c7 04 24 c4 63 00 00 	movl   $0x63c4,(%esp)
    3868:	e8 17 14 00 00       	call   4c84 <mkdir>
    386d:	85 c0                	test   %eax,%eax
    386f:	75 19                	jne    388a <fourteen+0x140>
    3871:	c7 44 24 04 e4 63 00 	movl   $0x63e4,0x4(%esp)
    3878:	00 
    3879:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3880:	e8 30 15 00 00       	call   4db5 <printf>
    3885:	e8 92 13 00 00       	call   4c1c <exit>
    388a:	c7 44 24 04 15 64 00 	movl   $0x6415,0x4(%esp)
    3891:	00 
    3892:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3899:	e8 17 15 00 00       	call   4db5 <printf>
    389e:	c9                   	leave  
    389f:	c3                   	ret    

000038a0 <rmdot>:
    38a0:	55                   	push   %ebp
    38a1:	89 e5                	mov    %esp,%ebp
    38a3:	83 ec 18             	sub    $0x18,%esp
    38a6:	c7 44 24 04 22 64 00 	movl   $0x6422,0x4(%esp)
    38ad:	00 
    38ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38b5:	e8 fb 14 00 00       	call   4db5 <printf>
    38ba:	c7 04 24 2e 64 00 00 	movl   $0x642e,(%esp)
    38c1:	e8 be 13 00 00       	call   4c84 <mkdir>
    38c6:	85 c0                	test   %eax,%eax
    38c8:	74 19                	je     38e3 <rmdot+0x43>
    38ca:	c7 44 24 04 33 64 00 	movl   $0x6433,0x4(%esp)
    38d1:	00 
    38d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38d9:	e8 d7 14 00 00       	call   4db5 <printf>
    38de:	e8 39 13 00 00       	call   4c1c <exit>
    38e3:	c7 04 24 2e 64 00 00 	movl   $0x642e,(%esp)
    38ea:	e8 9d 13 00 00       	call   4c8c <chdir>
    38ef:	85 c0                	test   %eax,%eax
    38f1:	74 19                	je     390c <rmdot+0x6c>
    38f3:	c7 44 24 04 46 64 00 	movl   $0x6446,0x4(%esp)
    38fa:	00 
    38fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3902:	e8 ae 14 00 00       	call   4db5 <printf>
    3907:	e8 10 13 00 00       	call   4c1c <exit>
    390c:	c7 04 24 5f 5b 00 00 	movl   $0x5b5f,(%esp)
    3913:	e8 54 13 00 00       	call   4c6c <unlink>
    3918:	85 c0                	test   %eax,%eax
    391a:	75 19                	jne    3935 <rmdot+0x95>
    391c:	c7 44 24 04 59 64 00 	movl   $0x6459,0x4(%esp)
    3923:	00 
    3924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    392b:	e8 85 14 00 00       	call   4db5 <printf>
    3930:	e8 e7 12 00 00       	call   4c1c <exit>
    3935:	c7 04 24 ec 56 00 00 	movl   $0x56ec,(%esp)
    393c:	e8 2b 13 00 00       	call   4c6c <unlink>
    3941:	85 c0                	test   %eax,%eax
    3943:	75 19                	jne    395e <rmdot+0xbe>
    3945:	c7 44 24 04 67 64 00 	movl   $0x6467,0x4(%esp)
    394c:	00 
    394d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3954:	e8 5c 14 00 00       	call   4db5 <printf>
    3959:	e8 be 12 00 00       	call   4c1c <exit>
    395e:	c7 04 24 76 64 00 00 	movl   $0x6476,(%esp)
    3965:	e8 22 13 00 00       	call   4c8c <chdir>
    396a:	85 c0                	test   %eax,%eax
    396c:	74 19                	je     3987 <rmdot+0xe7>
    396e:	c7 44 24 04 78 64 00 	movl   $0x6478,0x4(%esp)
    3975:	00 
    3976:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    397d:	e8 33 14 00 00       	call   4db5 <printf>
    3982:	e8 95 12 00 00       	call   4c1c <exit>
    3987:	c7 04 24 88 64 00 00 	movl   $0x6488,(%esp)
    398e:	e8 d9 12 00 00       	call   4c6c <unlink>
    3993:	85 c0                	test   %eax,%eax
    3995:	75 19                	jne    39b0 <rmdot+0x110>
    3997:	c7 44 24 04 8f 64 00 	movl   $0x648f,0x4(%esp)
    399e:	00 
    399f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39a6:	e8 0a 14 00 00       	call   4db5 <printf>
    39ab:	e8 6c 12 00 00       	call   4c1c <exit>
    39b0:	c7 04 24 a6 64 00 00 	movl   $0x64a6,(%esp)
    39b7:	e8 b0 12 00 00       	call   4c6c <unlink>
    39bc:	85 c0                	test   %eax,%eax
    39be:	75 19                	jne    39d9 <rmdot+0x139>
    39c0:	c7 44 24 04 ae 64 00 	movl   $0x64ae,0x4(%esp)
    39c7:	00 
    39c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39cf:	e8 e1 13 00 00       	call   4db5 <printf>
    39d4:	e8 43 12 00 00       	call   4c1c <exit>
    39d9:	c7 04 24 2e 64 00 00 	movl   $0x642e,(%esp)
    39e0:	e8 87 12 00 00       	call   4c6c <unlink>
    39e5:	85 c0                	test   %eax,%eax
    39e7:	74 19                	je     3a02 <rmdot+0x162>
    39e9:	c7 44 24 04 c6 64 00 	movl   $0x64c6,0x4(%esp)
    39f0:	00 
    39f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39f8:	e8 b8 13 00 00       	call   4db5 <printf>
    39fd:	e8 1a 12 00 00       	call   4c1c <exit>
    3a02:	c7 44 24 04 db 64 00 	movl   $0x64db,0x4(%esp)
    3a09:	00 
    3a0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a11:	e8 9f 13 00 00       	call   4db5 <printf>
    3a16:	c9                   	leave  
    3a17:	c3                   	ret    

00003a18 <dirfile>:
    3a18:	55                   	push   %ebp
    3a19:	89 e5                	mov    %esp,%ebp
    3a1b:	83 ec 28             	sub    $0x28,%esp
    3a1e:	c7 44 24 04 e5 64 00 	movl   $0x64e5,0x4(%esp)
    3a25:	00 
    3a26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a2d:	e8 83 13 00 00       	call   4db5 <printf>
    3a32:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3a39:	00 
    3a3a:	c7 04 24 f2 64 00 00 	movl   $0x64f2,(%esp)
    3a41:	e8 16 12 00 00       	call   4c5c <open>
    3a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3a4d:	79 19                	jns    3a68 <dirfile+0x50>
    3a4f:	c7 44 24 04 fa 64 00 	movl   $0x64fa,0x4(%esp)
    3a56:	00 
    3a57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a5e:	e8 52 13 00 00       	call   4db5 <printf>
    3a63:	e8 b4 11 00 00       	call   4c1c <exit>
    3a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a6b:	89 04 24             	mov    %eax,(%esp)
    3a6e:	e8 d1 11 00 00       	call   4c44 <close>
    3a73:	c7 04 24 f2 64 00 00 	movl   $0x64f2,(%esp)
    3a7a:	e8 0d 12 00 00       	call   4c8c <chdir>
    3a7f:	85 c0                	test   %eax,%eax
    3a81:	75 19                	jne    3a9c <dirfile+0x84>
    3a83:	c7 44 24 04 11 65 00 	movl   $0x6511,0x4(%esp)
    3a8a:	00 
    3a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a92:	e8 1e 13 00 00       	call   4db5 <printf>
    3a97:	e8 80 11 00 00       	call   4c1c <exit>
    3a9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3aa3:	00 
    3aa4:	c7 04 24 2b 65 00 00 	movl   $0x652b,(%esp)
    3aab:	e8 ac 11 00 00       	call   4c5c <open>
    3ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3ab7:	78 19                	js     3ad2 <dirfile+0xba>
    3ab9:	c7 44 24 04 36 65 00 	movl   $0x6536,0x4(%esp)
    3ac0:	00 
    3ac1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ac8:	e8 e8 12 00 00       	call   4db5 <printf>
    3acd:	e8 4a 11 00 00       	call   4c1c <exit>
    3ad2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3ad9:	00 
    3ada:	c7 04 24 2b 65 00 00 	movl   $0x652b,(%esp)
    3ae1:	e8 76 11 00 00       	call   4c5c <open>
    3ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3aed:	78 19                	js     3b08 <dirfile+0xf0>
    3aef:	c7 44 24 04 36 65 00 	movl   $0x6536,0x4(%esp)
    3af6:	00 
    3af7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3afe:	e8 b2 12 00 00       	call   4db5 <printf>
    3b03:	e8 14 11 00 00       	call   4c1c <exit>
    3b08:	c7 04 24 2b 65 00 00 	movl   $0x652b,(%esp)
    3b0f:	e8 70 11 00 00       	call   4c84 <mkdir>
    3b14:	85 c0                	test   %eax,%eax
    3b16:	75 19                	jne    3b31 <dirfile+0x119>
    3b18:	c7 44 24 04 54 65 00 	movl   $0x6554,0x4(%esp)
    3b1f:	00 
    3b20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b27:	e8 89 12 00 00       	call   4db5 <printf>
    3b2c:	e8 eb 10 00 00       	call   4c1c <exit>
    3b31:	c7 04 24 2b 65 00 00 	movl   $0x652b,(%esp)
    3b38:	e8 2f 11 00 00       	call   4c6c <unlink>
    3b3d:	85 c0                	test   %eax,%eax
    3b3f:	75 19                	jne    3b5a <dirfile+0x142>
    3b41:	c7 44 24 04 71 65 00 	movl   $0x6571,0x4(%esp)
    3b48:	00 
    3b49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b50:	e8 60 12 00 00       	call   4db5 <printf>
    3b55:	e8 c2 10 00 00       	call   4c1c <exit>
    3b5a:	c7 44 24 04 2b 65 00 	movl   $0x652b,0x4(%esp)
    3b61:	00 
    3b62:	c7 04 24 8f 65 00 00 	movl   $0x658f,(%esp)
    3b69:	e8 0e 11 00 00       	call   4c7c <link>
    3b6e:	85 c0                	test   %eax,%eax
    3b70:	75 19                	jne    3b8b <dirfile+0x173>
    3b72:	c7 44 24 04 98 65 00 	movl   $0x6598,0x4(%esp)
    3b79:	00 
    3b7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b81:	e8 2f 12 00 00       	call   4db5 <printf>
    3b86:	e8 91 10 00 00       	call   4c1c <exit>
    3b8b:	c7 04 24 f2 64 00 00 	movl   $0x64f2,(%esp)
    3b92:	e8 d5 10 00 00       	call   4c6c <unlink>
    3b97:	85 c0                	test   %eax,%eax
    3b99:	74 19                	je     3bb4 <dirfile+0x19c>
    3b9b:	c7 44 24 04 b7 65 00 	movl   $0x65b7,0x4(%esp)
    3ba2:	00 
    3ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3baa:	e8 06 12 00 00       	call   4db5 <printf>
    3baf:	e8 68 10 00 00       	call   4c1c <exit>
    3bb4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    3bbb:	00 
    3bbc:	c7 04 24 5f 5b 00 00 	movl   $0x5b5f,(%esp)
    3bc3:	e8 94 10 00 00       	call   4c5c <open>
    3bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3bcf:	78 19                	js     3bea <dirfile+0x1d2>
    3bd1:	c7 44 24 04 d0 65 00 	movl   $0x65d0,0x4(%esp)
    3bd8:	00 
    3bd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3be0:	e8 d0 11 00 00       	call   4db5 <printf>
    3be5:	e8 32 10 00 00       	call   4c1c <exit>
    3bea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3bf1:	00 
    3bf2:	c7 04 24 5f 5b 00 00 	movl   $0x5b5f,(%esp)
    3bf9:	e8 5e 10 00 00       	call   4c5c <open>
    3bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3c01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3c08:	00 
    3c09:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    3c10:	00 
    3c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c14:	89 04 24             	mov    %eax,(%esp)
    3c17:	e8 20 10 00 00       	call   4c3c <write>
    3c1c:	85 c0                	test   %eax,%eax
    3c1e:	7e 19                	jle    3c39 <dirfile+0x221>
    3c20:	c7 44 24 04 ef 65 00 	movl   $0x65ef,0x4(%esp)
    3c27:	00 
    3c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c2f:	e8 81 11 00 00       	call   4db5 <printf>
    3c34:	e8 e3 0f 00 00       	call   4c1c <exit>
    3c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c3c:	89 04 24             	mov    %eax,(%esp)
    3c3f:	e8 00 10 00 00       	call   4c44 <close>
    3c44:	c7 44 24 04 03 66 00 	movl   $0x6603,0x4(%esp)
    3c4b:	00 
    3c4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c53:	e8 5d 11 00 00       	call   4db5 <printf>
    3c58:	c9                   	leave  
    3c59:	c3                   	ret    

00003c5a <iref>:
    3c5a:	55                   	push   %ebp
    3c5b:	89 e5                	mov    %esp,%ebp
    3c5d:	83 ec 28             	sub    $0x28,%esp
    3c60:	c7 44 24 04 13 66 00 	movl   $0x6613,0x4(%esp)
    3c67:	00 
    3c68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c6f:	e8 41 11 00 00       	call   4db5 <printf>
    3c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3c7b:	e9 d2 00 00 00       	jmp    3d52 <iref+0xf8>
    3c80:	c7 04 24 24 66 00 00 	movl   $0x6624,(%esp)
    3c87:	e8 f8 0f 00 00       	call   4c84 <mkdir>
    3c8c:	85 c0                	test   %eax,%eax
    3c8e:	74 19                	je     3ca9 <iref+0x4f>
    3c90:	c7 44 24 04 2a 66 00 	movl   $0x662a,0x4(%esp)
    3c97:	00 
    3c98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c9f:	e8 11 11 00 00       	call   4db5 <printf>
    3ca4:	e8 73 0f 00 00       	call   4c1c <exit>
    3ca9:	c7 04 24 24 66 00 00 	movl   $0x6624,(%esp)
    3cb0:	e8 d7 0f 00 00       	call   4c8c <chdir>
    3cb5:	85 c0                	test   %eax,%eax
    3cb7:	74 19                	je     3cd2 <iref+0x78>
    3cb9:	c7 44 24 04 3e 66 00 	movl   $0x663e,0x4(%esp)
    3cc0:	00 
    3cc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3cc8:	e8 e8 10 00 00       	call   4db5 <printf>
    3ccd:	e8 4a 0f 00 00       	call   4c1c <exit>
    3cd2:	c7 04 24 52 66 00 00 	movl   $0x6652,(%esp)
    3cd9:	e8 a6 0f 00 00       	call   4c84 <mkdir>
    3cde:	c7 44 24 04 52 66 00 	movl   $0x6652,0x4(%esp)
    3ce5:	00 
    3ce6:	c7 04 24 8f 65 00 00 	movl   $0x658f,(%esp)
    3ced:	e8 8a 0f 00 00       	call   4c7c <link>
    3cf2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3cf9:	00 
    3cfa:	c7 04 24 52 66 00 00 	movl   $0x6652,(%esp)
    3d01:	e8 56 0f 00 00       	call   4c5c <open>
    3d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d0d:	78 0b                	js     3d1a <iref+0xc0>
    3d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d12:	89 04 24             	mov    %eax,(%esp)
    3d15:	e8 2a 0f 00 00       	call   4c44 <close>
    3d1a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3d21:	00 
    3d22:	c7 04 24 53 66 00 00 	movl   $0x6653,(%esp)
    3d29:	e8 2e 0f 00 00       	call   4c5c <open>
    3d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d35:	78 0b                	js     3d42 <iref+0xe8>
    3d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d3a:	89 04 24             	mov    %eax,(%esp)
    3d3d:	e8 02 0f 00 00       	call   4c44 <close>
    3d42:	c7 04 24 53 66 00 00 	movl   $0x6653,(%esp)
    3d49:	e8 1e 0f 00 00       	call   4c6c <unlink>
    3d4e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3d52:	83 7d f0 32          	cmpl   $0x32,-0x10(%ebp)
    3d56:	0f 8e 24 ff ff ff    	jle    3c80 <iref+0x26>
    3d5c:	c7 04 24 76 64 00 00 	movl   $0x6476,(%esp)
    3d63:	e8 24 0f 00 00       	call   4c8c <chdir>
    3d68:	c7 44 24 04 56 66 00 	movl   $0x6656,0x4(%esp)
    3d6f:	00 
    3d70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d77:	e8 39 10 00 00       	call   4db5 <printf>
    3d7c:	c9                   	leave  
    3d7d:	c3                   	ret    

00003d7e <forktest>:
    3d7e:	55                   	push   %ebp
    3d7f:	89 e5                	mov    %esp,%ebp
    3d81:	83 ec 28             	sub    $0x28,%esp
    3d84:	c7 44 24 04 6a 66 00 	movl   $0x666a,0x4(%esp)
    3d8b:	00 
    3d8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d93:	e8 1d 10 00 00       	call   4db5 <printf>
    3d98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3d9f:	eb 1d                	jmp    3dbe <forktest+0x40>
    3da1:	e8 6e 0e 00 00       	call   4c14 <fork>
    3da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3da9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3dad:	78 1a                	js     3dc9 <forktest+0x4b>
    3daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3db3:	75 05                	jne    3dba <forktest+0x3c>
    3db5:	e8 62 0e 00 00       	call   4c1c <exit>
    3dba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3dbe:	81 7d f0 e7 03 00 00 	cmpl   $0x3e7,-0x10(%ebp)
    3dc5:	7e da                	jle    3da1 <forktest+0x23>
    3dc7:	eb 01                	jmp    3dca <forktest+0x4c>
    3dc9:	90                   	nop
    3dca:	81 7d f0 e8 03 00 00 	cmpl   $0x3e8,-0x10(%ebp)
    3dd1:	75 3f                	jne    3e12 <forktest+0x94>
    3dd3:	c7 44 24 04 78 66 00 	movl   $0x6678,0x4(%esp)
    3dda:	00 
    3ddb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3de2:	e8 ce 0f 00 00       	call   4db5 <printf>
    3de7:	e8 30 0e 00 00       	call   4c1c <exit>
    3dec:	e8 33 0e 00 00       	call   4c24 <wait>
    3df1:	85 c0                	test   %eax,%eax
    3df3:	79 19                	jns    3e0e <forktest+0x90>
    3df5:	c7 44 24 04 9a 66 00 	movl   $0x669a,0x4(%esp)
    3dfc:	00 
    3dfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e04:	e8 ac 0f 00 00       	call   4db5 <printf>
    3e09:	e8 0e 0e 00 00       	call   4c1c <exit>
    3e0e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
    3e12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3e16:	7f d4                	jg     3dec <forktest+0x6e>
    3e18:	e8 07 0e 00 00       	call   4c24 <wait>
    3e1d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3e20:	74 19                	je     3e3b <forktest+0xbd>
    3e22:	c7 44 24 04 ae 66 00 	movl   $0x66ae,0x4(%esp)
    3e29:	00 
    3e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e31:	e8 7f 0f 00 00       	call   4db5 <printf>
    3e36:	e8 e1 0d 00 00       	call   4c1c <exit>
    3e3b:	c7 44 24 04 c1 66 00 	movl   $0x66c1,0x4(%esp)
    3e42:	00 
    3e43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e4a:	e8 66 0f 00 00       	call   4db5 <printf>
    3e4f:	c9                   	leave  
    3e50:	c3                   	ret    

00003e51 <sbrktest>:
    3e51:	55                   	push   %ebp
    3e52:	89 e5                	mov    %esp,%ebp
    3e54:	53                   	push   %ebx
    3e55:	81 ec 84 00 00 00    	sub    $0x84,%esp
    3e5b:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    3e60:	c7 44 24 04 cf 66 00 	movl   $0x66cf,0x4(%esp)
    3e67:	00 
    3e68:	89 04 24             	mov    %eax,(%esp)
    3e6b:	e8 45 0f 00 00       	call   4db5 <printf>
    3e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e77:	e8 28 0e 00 00       	call   4ca4 <sbrk>
    3e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    3e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3e86:	e8 19 0e 00 00       	call   4ca4 <sbrk>
    3e8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    3e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3e95:	eb 59                	jmp    3ef0 <sbrktest+0x9f>
    3e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e9e:	e8 01 0e 00 00       	call   4ca4 <sbrk>
    3ea3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    3ea6:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3ea9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    3eac:	74 2f                	je     3edd <sbrktest+0x8c>
    3eae:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    3eb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
    3eb6:	89 54 24 10          	mov    %edx,0x10(%esp)
    3eba:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3ebd:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3ec4:	89 54 24 08          	mov    %edx,0x8(%esp)
    3ec8:	c7 44 24 04 da 66 00 	movl   $0x66da,0x4(%esp)
    3ecf:	00 
    3ed0:	89 04 24             	mov    %eax,(%esp)
    3ed3:	e8 dd 0e 00 00       	call   4db5 <printf>
    3ed8:	e8 3f 0d 00 00       	call   4c1c <exit>
    3edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3ee0:	c6 00 01             	movb   $0x1,(%eax)
    3ee3:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3ee6:	83 c0 01             	add    $0x1,%eax
    3ee9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    3eec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3ef0:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
    3ef7:	7e 9e                	jle    3e97 <sbrktest+0x46>
    3ef9:	e8 16 0d 00 00       	call   4c14 <fork>
    3efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3f01:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    3f05:	79 1a                	jns    3f21 <sbrktest+0xd0>
    3f07:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    3f0c:	c7 44 24 04 f5 66 00 	movl   $0x66f5,0x4(%esp)
    3f13:	00 
    3f14:	89 04 24             	mov    %eax,(%esp)
    3f17:	e8 99 0e 00 00       	call   4db5 <printf>
    3f1c:	e8 fb 0c 00 00       	call   4c1c <exit>
    3f21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f28:	e8 77 0d 00 00       	call   4ca4 <sbrk>
    3f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    3f30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f37:	e8 68 0d 00 00       	call   4ca4 <sbrk>
    3f3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    3f3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3f42:	83 c0 01             	add    $0x1,%eax
    3f45:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3f48:	74 1a                	je     3f64 <sbrktest+0x113>
    3f4a:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    3f4f:	c7 44 24 04 0c 67 00 	movl   $0x670c,0x4(%esp)
    3f56:	00 
    3f57:	89 04 24             	mov    %eax,(%esp)
    3f5a:	e8 56 0e 00 00       	call   4db5 <printf>
    3f5f:	e8 b8 0c 00 00       	call   4c1c <exit>
    3f64:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    3f68:	75 05                	jne    3f6f <sbrktest+0x11e>
    3f6a:	e8 ad 0c 00 00       	call   4c1c <exit>
    3f6f:	e8 b0 0c 00 00       	call   4c24 <wait>
    3f74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3f7b:	e8 24 0d 00 00       	call   4ca4 <sbrk>
    3f80:	89 45 d8             	mov    %eax,-0x28(%ebp)
    3f83:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3f86:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3f8b:	89 d1                	mov    %edx,%ecx
    3f8d:	29 c1                	sub    %eax,%ecx
    3f8f:	89 c8                	mov    %ecx,%eax
    3f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    3f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3f97:	89 04 24             	mov    %eax,(%esp)
    3f9a:	e8 05 0d 00 00       	call   4ca4 <sbrk>
    3f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fa5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    3fa8:	74 1a                	je     3fc4 <sbrktest+0x173>
    3faa:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    3faf:	c7 44 24 04 28 67 00 	movl   $0x6728,0x4(%esp)
    3fb6:	00 
    3fb7:	89 04 24             	mov    %eax,(%esp)
    3fba:	e8 f6 0d 00 00       	call   4db5 <printf>
    3fbf:	e8 58 0c 00 00       	call   4c1c <exit>
    3fc4:	c7 45 e4 ff ff 3f 06 	movl   $0x63fffff,-0x1c(%ebp)
    3fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3fce:	c6 00 63             	movb   $0x63,(%eax)
    3fd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3fd8:	e8 c7 0c 00 00       	call   4ca4 <sbrk>
    3fdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
    3fe0:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3fe7:	e8 b8 0c 00 00       	call   4ca4 <sbrk>
    3fec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    3fef:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3ff3:	75 1a                	jne    400f <sbrktest+0x1be>
    3ff5:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    3ffa:	c7 44 24 04 66 67 00 	movl   $0x6766,0x4(%esp)
    4001:	00 
    4002:	89 04 24             	mov    %eax,(%esp)
    4005:	e8 ab 0d 00 00       	call   4db5 <printf>
    400a:	e8 0d 0c 00 00       	call   4c1c <exit>
    400f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4016:	e8 89 0c 00 00       	call   4ca4 <sbrk>
    401b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    401e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    4021:	2d 00 10 00 00       	sub    $0x1000,%eax
    4026:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    4029:	74 28                	je     4053 <sbrktest+0x202>
    402b:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4030:	8b 55 e0             	mov    -0x20(%ebp),%edx
    4033:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4037:	8b 55 d8             	mov    -0x28(%ebp),%edx
    403a:	89 54 24 08          	mov    %edx,0x8(%esp)
    403e:	c7 44 24 04 84 67 00 	movl   $0x6784,0x4(%esp)
    4045:	00 
    4046:	89 04 24             	mov    %eax,(%esp)
    4049:	e8 67 0d 00 00       	call   4db5 <printf>
    404e:	e8 c9 0b 00 00       	call   4c1c <exit>
    4053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    405a:	e8 45 0c 00 00       	call   4ca4 <sbrk>
    405f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    4062:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    4069:	e8 36 0c 00 00       	call   4ca4 <sbrk>
    406e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    4071:	8b 45 e0             	mov    -0x20(%ebp),%eax
    4074:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    4077:	75 19                	jne    4092 <sbrktest+0x241>
    4079:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4080:	e8 1f 0c 00 00       	call   4ca4 <sbrk>
    4085:	8b 55 d8             	mov    -0x28(%ebp),%edx
    4088:	81 c2 00 10 00 00    	add    $0x1000,%edx
    408e:	39 d0                	cmp    %edx,%eax
    4090:	74 28                	je     40ba <sbrktest+0x269>
    4092:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4097:	8b 55 e0             	mov    -0x20(%ebp),%edx
    409a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    409e:	8b 55 d8             	mov    -0x28(%ebp),%edx
    40a1:	89 54 24 08          	mov    %edx,0x8(%esp)
    40a5:	c7 44 24 04 bc 67 00 	movl   $0x67bc,0x4(%esp)
    40ac:	00 
    40ad:	89 04 24             	mov    %eax,(%esp)
    40b0:	e8 00 0d 00 00       	call   4db5 <printf>
    40b5:	e8 62 0b 00 00       	call   4c1c <exit>
    40ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    40bd:	0f b6 00             	movzbl (%eax),%eax
    40c0:	3c 63                	cmp    $0x63,%al
    40c2:	75 1a                	jne    40de <sbrktest+0x28d>
    40c4:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    40c9:	c7 44 24 04 e4 67 00 	movl   $0x67e4,0x4(%esp)
    40d0:	00 
    40d1:	89 04 24             	mov    %eax,(%esp)
    40d4:	e8 dc 0c 00 00       	call   4db5 <printf>
    40d9:	e8 3e 0b 00 00       	call   4c1c <exit>
    40de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    40e5:	e8 ba 0b 00 00       	call   4ca4 <sbrk>
    40ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
    40ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
    40f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    40f7:	e8 a8 0b 00 00       	call   4ca4 <sbrk>
    40fc:	89 da                	mov    %ebx,%edx
    40fe:	29 c2                	sub    %eax,%edx
    4100:	89 d0                	mov    %edx,%eax
    4102:	89 04 24             	mov    %eax,(%esp)
    4105:	e8 9a 0b 00 00       	call   4ca4 <sbrk>
    410a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    410d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    4110:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    4113:	74 28                	je     413d <sbrktest+0x2ec>
    4115:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    411a:	8b 55 e0             	mov    -0x20(%ebp),%edx
    411d:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4121:	8b 55 d8             	mov    -0x28(%ebp),%edx
    4124:	89 54 24 08          	mov    %edx,0x8(%esp)
    4128:	c7 44 24 04 14 68 00 	movl   $0x6814,0x4(%esp)
    412f:	00 
    4130:	89 04 24             	mov    %eax,(%esp)
    4133:	e8 7d 0c 00 00       	call   4db5 <printf>
    4138:	e8 df 0a 00 00       	call   4c1c <exit>
    413d:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
    4144:	eb 7b                	jmp    41c1 <sbrktest+0x370>
    4146:	e8 51 0b 00 00       	call   4c9c <getpid>
    414b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    414e:	e8 c1 0a 00 00       	call   4c14 <fork>
    4153:	89 45 d0             	mov    %eax,-0x30(%ebp)
    4156:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    415a:	79 1a                	jns    4176 <sbrktest+0x325>
    415c:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4161:	c7 44 24 04 dd 57 00 	movl   $0x57dd,0x4(%esp)
    4168:	00 
    4169:	89 04 24             	mov    %eax,(%esp)
    416c:	e8 44 0c 00 00       	call   4db5 <printf>
    4171:	e8 a6 0a 00 00       	call   4c1c <exit>
    4176:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    417a:	75 39                	jne    41b5 <sbrktest+0x364>
    417c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    417f:	0f b6 00             	movzbl (%eax),%eax
    4182:	0f be d0             	movsbl %al,%edx
    4185:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    418a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    418e:	8b 55 d8             	mov    -0x28(%ebp),%edx
    4191:	89 54 24 08          	mov    %edx,0x8(%esp)
    4195:	c7 44 24 04 35 68 00 	movl   $0x6835,0x4(%esp)
    419c:	00 
    419d:	89 04 24             	mov    %eax,(%esp)
    41a0:	e8 10 0c 00 00       	call   4db5 <printf>
    41a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    41a8:	89 04 24             	mov    %eax,(%esp)
    41ab:	e8 9c 0a 00 00       	call   4c4c <kill>
    41b0:	e8 67 0a 00 00       	call   4c1c <exit>
    41b5:	e8 6a 0a 00 00       	call   4c24 <wait>
    41ba:	81 45 d8 50 c3 00 00 	addl   $0xc350,-0x28(%ebp)
    41c1:	81 7d d8 7f 84 1e 80 	cmpl   $0x801e847f,-0x28(%ebp)
    41c8:	0f 86 78 ff ff ff    	jbe    4146 <sbrktest+0x2f5>
    41ce:	8d 45 c8             	lea    -0x38(%ebp),%eax
    41d1:	89 04 24             	mov    %eax,(%esp)
    41d4:	e8 53 0a 00 00       	call   4c2c <pipe>
    41d9:	85 c0                	test   %eax,%eax
    41db:	74 19                	je     41f6 <sbrktest+0x3a5>
    41dd:	c7 44 24 04 31 57 00 	movl   $0x5731,0x4(%esp)
    41e4:	00 
    41e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    41ec:	e8 c4 0b 00 00       	call   4db5 <printf>
    41f1:	e8 26 0a 00 00       	call   4c1c <exit>
    41f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    41fd:	e9 86 00 00 00       	jmp    4288 <sbrktest+0x437>
    4202:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    4205:	e8 0a 0a 00 00       	call   4c14 <fork>
    420a:	89 44 9d a0          	mov    %eax,-0x60(%ebp,%ebx,4)
    420e:	8b 44 9d a0          	mov    -0x60(%ebp,%ebx,4),%eax
    4212:	85 c0                	test   %eax,%eax
    4214:	75 48                	jne    425e <sbrktest+0x40d>
    4216:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    421d:	e8 82 0a 00 00       	call   4ca4 <sbrk>
    4222:	ba 00 00 40 06       	mov    $0x6400000,%edx
    4227:	89 d1                	mov    %edx,%ecx
    4229:	29 c1                	sub    %eax,%ecx
    422b:	89 c8                	mov    %ecx,%eax
    422d:	89 04 24             	mov    %eax,(%esp)
    4230:	e8 6f 0a 00 00       	call   4ca4 <sbrk>
    4235:	8b 45 cc             	mov    -0x34(%ebp),%eax
    4238:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    423f:	00 
    4240:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    4247:	00 
    4248:	89 04 24             	mov    %eax,(%esp)
    424b:	e8 ec 09 00 00       	call   4c3c <write>
    4250:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    4257:	e8 50 0a 00 00       	call   4cac <sleep>
    425c:	eb f2                	jmp    4250 <sbrktest+0x3ff>
    425e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4261:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    4265:	83 f8 ff             	cmp    $0xffffffff,%eax
    4268:	74 1a                	je     4284 <sbrktest+0x433>
    426a:	8b 45 c8             	mov    -0x38(%ebp),%eax
    426d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4274:	00 
    4275:	8d 55 9f             	lea    -0x61(%ebp),%edx
    4278:	89 54 24 04          	mov    %edx,0x4(%esp)
    427c:	89 04 24             	mov    %eax,(%esp)
    427f:	e8 b0 09 00 00       	call   4c34 <read>
    4284:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    428b:	83 f8 09             	cmp    $0x9,%eax
    428e:	0f 86 6e ff ff ff    	jbe    4202 <sbrktest+0x3b1>
    4294:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    429b:	e8 04 0a 00 00       	call   4ca4 <sbrk>
    42a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    42a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    42aa:	eb 27                	jmp    42d3 <sbrktest+0x482>
    42ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42af:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    42b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    42b6:	74 16                	je     42ce <sbrktest+0x47d>
    42b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42bb:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    42bf:	89 04 24             	mov    %eax,(%esp)
    42c2:	e8 85 09 00 00       	call   4c4c <kill>
    42c7:	e8 58 09 00 00       	call   4c24 <wait>
    42cc:	eb 01                	jmp    42cf <sbrktest+0x47e>
    42ce:	90                   	nop
    42cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    42d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42d6:	83 f8 09             	cmp    $0x9,%eax
    42d9:	76 d1                	jbe    42ac <sbrktest+0x45b>
    42db:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    42df:	75 1a                	jne    42fb <sbrktest+0x4aa>
    42e1:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    42e6:	c7 44 24 04 4e 68 00 	movl   $0x684e,0x4(%esp)
    42ed:	00 
    42ee:	89 04 24             	mov    %eax,(%esp)
    42f1:	e8 bf 0a 00 00       	call   4db5 <printf>
    42f6:	e8 21 09 00 00       	call   4c1c <exit>
    42fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4302:	e8 9d 09 00 00       	call   4ca4 <sbrk>
    4307:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    430a:	76 1d                	jbe    4329 <sbrktest+0x4d8>
    430c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
    430f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4316:	e8 89 09 00 00       	call   4ca4 <sbrk>
    431b:	89 da                	mov    %ebx,%edx
    431d:	29 c2                	sub    %eax,%edx
    431f:	89 d0                	mov    %edx,%eax
    4321:	89 04 24             	mov    %eax,(%esp)
    4324:	e8 7b 09 00 00       	call   4ca4 <sbrk>
    4329:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    432e:	c7 44 24 04 69 68 00 	movl   $0x6869,0x4(%esp)
    4335:	00 
    4336:	89 04 24             	mov    %eax,(%esp)
    4339:	e8 77 0a 00 00       	call   4db5 <printf>
    433e:	81 c4 84 00 00 00    	add    $0x84,%esp
    4344:	5b                   	pop    %ebx
    4345:	5d                   	pop    %ebp
    4346:	c3                   	ret    

00004347 <validateint>:
    4347:	55                   	push   %ebp
    4348:	89 e5                	mov    %esp,%ebp
    434a:	53                   	push   %ebx
    434b:	83 ec 10             	sub    $0x10,%esp
    434e:	b8 0d 00 00 00       	mov    $0xd,%eax
    4353:	8b 55 08             	mov    0x8(%ebp),%edx
    4356:	89 d1                	mov    %edx,%ecx
    4358:	89 e3                	mov    %esp,%ebx
    435a:	89 cc                	mov    %ecx,%esp
    435c:	cd 40                	int    $0x40
    435e:	89 dc                	mov    %ebx,%esp
    4360:	89 45 f8             	mov    %eax,-0x8(%ebp)
    4363:	83 c4 10             	add    $0x10,%esp
    4366:	5b                   	pop    %ebx
    4367:	5d                   	pop    %ebp
    4368:	c3                   	ret    

00004369 <validatetest>:
    4369:	55                   	push   %ebp
    436a:	89 e5                	mov    %esp,%ebp
    436c:	83 ec 28             	sub    $0x28,%esp
    436f:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4374:	c7 44 24 04 77 68 00 	movl   $0x6877,0x4(%esp)
    437b:	00 
    437c:	89 04 24             	mov    %eax,(%esp)
    437f:	e8 31 0a 00 00       	call   4db5 <printf>
    4384:	c7 45 ec 00 30 11 00 	movl   $0x113000,-0x14(%ebp)
    438b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4392:	eb 7f                	jmp    4413 <validatetest+0xaa>
    4394:	e8 7b 08 00 00       	call   4c14 <fork>
    4399:	89 45 f0             	mov    %eax,-0x10(%ebp)
    439c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    43a0:	75 10                	jne    43b2 <validatetest+0x49>
    43a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a5:	89 04 24             	mov    %eax,(%esp)
    43a8:	e8 9a ff ff ff       	call   4347 <validateint>
    43ad:	e8 6a 08 00 00       	call   4c1c <exit>
    43b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    43b9:	e8 ee 08 00 00       	call   4cac <sleep>
    43be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    43c5:	e8 e2 08 00 00       	call   4cac <sleep>
    43ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43cd:	89 04 24             	mov    %eax,(%esp)
    43d0:	e8 77 08 00 00       	call   4c4c <kill>
    43d5:	e8 4a 08 00 00       	call   4c24 <wait>
    43da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    43e1:	c7 04 24 86 68 00 00 	movl   $0x6886,(%esp)
    43e8:	e8 8f 08 00 00       	call   4c7c <link>
    43ed:	83 f8 ff             	cmp    $0xffffffff,%eax
    43f0:	74 1a                	je     440c <validatetest+0xa3>
    43f2:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    43f7:	c7 44 24 04 91 68 00 	movl   $0x6891,0x4(%esp)
    43fe:	00 
    43ff:	89 04 24             	mov    %eax,(%esp)
    4402:	e8 ae 09 00 00       	call   4db5 <printf>
    4407:	e8 10 08 00 00       	call   4c1c <exit>
    440c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    4413:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4416:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    4419:	0f 83 75 ff ff ff    	jae    4394 <validatetest+0x2b>
    441f:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4424:	c7 44 24 04 aa 68 00 	movl   $0x68aa,0x4(%esp)
    442b:	00 
    442c:	89 04 24             	mov    %eax,(%esp)
    442f:	e8 81 09 00 00       	call   4db5 <printf>
    4434:	c9                   	leave  
    4435:	c3                   	ret    

00004436 <bsstest>:
    4436:	55                   	push   %ebp
    4437:	89 e5                	mov    %esp,%ebp
    4439:	83 ec 28             	sub    $0x28,%esp
    443c:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4441:	c7 44 24 04 b7 68 00 	movl   $0x68b7,0x4(%esp)
    4448:	00 
    4449:	89 04 24             	mov    %eax,(%esp)
    444c:	e8 64 09 00 00       	call   4db5 <printf>
    4451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4458:	eb 2c                	jmp    4486 <bsstest+0x50>
    445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    445d:	0f b6 80 c0 6b 00 00 	movzbl 0x6bc0(%eax),%eax
    4464:	84 c0                	test   %al,%al
    4466:	74 1a                	je     4482 <bsstest+0x4c>
    4468:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    446d:	c7 44 24 04 c1 68 00 	movl   $0x68c1,0x4(%esp)
    4474:	00 
    4475:	89 04 24             	mov    %eax,(%esp)
    4478:	e8 38 09 00 00       	call   4db5 <printf>
    447d:	e8 9a 07 00 00       	call   4c1c <exit>
    4482:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4486:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4489:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    448e:	76 ca                	jbe    445a <bsstest+0x24>
    4490:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4495:	c7 44 24 04 d2 68 00 	movl   $0x68d2,0x4(%esp)
    449c:	00 
    449d:	89 04 24             	mov    %eax,(%esp)
    44a0:	e8 10 09 00 00       	call   4db5 <printf>
    44a5:	c9                   	leave  
    44a6:	c3                   	ret    

000044a7 <bigargtest>:
    44a7:	55                   	push   %ebp
    44a8:	89 e5                	mov    %esp,%ebp
    44aa:	83 ec 28             	sub    $0x28,%esp
    44ad:	c7 04 24 df 68 00 00 	movl   $0x68df,(%esp)
    44b4:	e8 b3 07 00 00       	call   4c6c <unlink>
    44b9:	e8 56 07 00 00       	call   4c14 <fork>
    44be:	89 45 ec             	mov    %eax,-0x14(%ebp)
    44c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    44c5:	0f 85 90 00 00 00    	jne    455b <bigargtest+0xb4>
    44cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    44d2:	eb 12                	jmp    44e6 <bigargtest+0x3f>
    44d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44d7:	c7 04 85 20 6b 00 00 	movl   $0x68ec,0x6b20(,%eax,4)
    44de:	ec 68 00 00 
    44e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    44e6:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    44ea:	7e e8                	jle    44d4 <bigargtest+0x2d>
    44ec:	c7 05 9c 6b 00 00 00 	movl   $0x0,0x6b9c
    44f3:	00 00 00 
    44f6:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    44fb:	c7 44 24 04 c9 69 00 	movl   $0x69c9,0x4(%esp)
    4502:	00 
    4503:	89 04 24             	mov    %eax,(%esp)
    4506:	e8 aa 08 00 00       	call   4db5 <printf>
    450b:	c7 44 24 04 20 6b 00 	movl   $0x6b20,0x4(%esp)
    4512:	00 
    4513:	c7 04 24 f0 53 00 00 	movl   $0x53f0,(%esp)
    451a:	e8 35 07 00 00       	call   4c54 <exec>
    451f:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4524:	c7 44 24 04 d6 69 00 	movl   $0x69d6,0x4(%esp)
    452b:	00 
    452c:	89 04 24             	mov    %eax,(%esp)
    452f:	e8 81 08 00 00       	call   4db5 <printf>
    4534:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    453b:	00 
    453c:	c7 04 24 df 68 00 00 	movl   $0x68df,(%esp)
    4543:	e8 14 07 00 00       	call   4c5c <open>
    4548:	89 45 f0             	mov    %eax,-0x10(%ebp)
    454b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    454e:	89 04 24             	mov    %eax,(%esp)
    4551:	e8 ee 06 00 00       	call   4c44 <close>
    4556:	e8 c1 06 00 00       	call   4c1c <exit>
    455b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    455f:	79 1a                	jns    457b <bigargtest+0xd4>
    4561:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    4566:	c7 44 24 04 e6 69 00 	movl   $0x69e6,0x4(%esp)
    456d:	00 
    456e:	89 04 24             	mov    %eax,(%esp)
    4571:	e8 3f 08 00 00       	call   4db5 <printf>
    4576:	e8 a1 06 00 00       	call   4c1c <exit>
    457b:	e8 a4 06 00 00       	call   4c24 <wait>
    4580:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4587:	00 
    4588:	c7 04 24 df 68 00 00 	movl   $0x68df,(%esp)
    458f:	e8 c8 06 00 00       	call   4c5c <open>
    4594:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4597:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    459b:	79 1a                	jns    45b7 <bigargtest+0x110>
    459d:	a1 fc 6a 00 00       	mov    0x6afc,%eax
    45a2:	c7 44 24 04 ff 69 00 	movl   $0x69ff,0x4(%esp)
    45a9:	00 
    45aa:	89 04 24             	mov    %eax,(%esp)
    45ad:	e8 03 08 00 00       	call   4db5 <printf>
    45b2:	e8 65 06 00 00       	call   4c1c <exit>
    45b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    45ba:	89 04 24             	mov    %eax,(%esp)
    45bd:	e8 82 06 00 00       	call   4c44 <close>
    45c2:	c7 04 24 df 68 00 00 	movl   $0x68df,(%esp)
    45c9:	e8 9e 06 00 00       	call   4c6c <unlink>
    45ce:	c9                   	leave  
    45cf:	c3                   	ret    

000045d0 <fsfull>:
    45d0:	55                   	push   %ebp
    45d1:	89 e5                	mov    %esp,%ebp
    45d3:	53                   	push   %ebx
    45d4:	83 ec 74             	sub    $0x74,%esp
    45d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    45de:	c7 44 24 04 14 6a 00 	movl   $0x6a14,0x4(%esp)
    45e5:	00 
    45e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    45ed:	e8 c3 07 00 00       	call   4db5 <printf>
    45f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    45f9:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    45fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    4600:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4605:	89 c8                	mov    %ecx,%eax
    4607:	f7 ea                	imul   %edx
    4609:	c1 fa 06             	sar    $0x6,%edx
    460c:	89 c8                	mov    %ecx,%eax
    460e:	c1 f8 1f             	sar    $0x1f,%eax
    4611:	89 d1                	mov    %edx,%ecx
    4613:	29 c1                	sub    %eax,%ecx
    4615:	89 c8                	mov    %ecx,%eax
    4617:	83 c0 30             	add    $0x30,%eax
    461a:	88 45 a5             	mov    %al,-0x5b(%ebp)
    461d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    4620:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4625:	89 d8                	mov    %ebx,%eax
    4627:	f7 ea                	imul   %edx
    4629:	c1 fa 06             	sar    $0x6,%edx
    462c:	89 d8                	mov    %ebx,%eax
    462e:	c1 f8 1f             	sar    $0x1f,%eax
    4631:	89 d1                	mov    %edx,%ecx
    4633:	29 c1                	sub    %eax,%ecx
    4635:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    463b:	89 d9                	mov    %ebx,%ecx
    463d:	29 c1                	sub    %eax,%ecx
    463f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    4644:	89 c8                	mov    %ecx,%eax
    4646:	f7 ea                	imul   %edx
    4648:	c1 fa 05             	sar    $0x5,%edx
    464b:	89 c8                	mov    %ecx,%eax
    464d:	c1 f8 1f             	sar    $0x1f,%eax
    4650:	89 d1                	mov    %edx,%ecx
    4652:	29 c1                	sub    %eax,%ecx
    4654:	89 c8                	mov    %ecx,%eax
    4656:	83 c0 30             	add    $0x30,%eax
    4659:	88 45 a6             	mov    %al,-0x5a(%ebp)
    465c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    465f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    4664:	89 d8                	mov    %ebx,%eax
    4666:	f7 ea                	imul   %edx
    4668:	c1 fa 05             	sar    $0x5,%edx
    466b:	89 d8                	mov    %ebx,%eax
    466d:	c1 f8 1f             	sar    $0x1f,%eax
    4670:	89 d1                	mov    %edx,%ecx
    4672:	29 c1                	sub    %eax,%ecx
    4674:	6b c1 64             	imul   $0x64,%ecx,%eax
    4677:	89 d9                	mov    %ebx,%ecx
    4679:	29 c1                	sub    %eax,%ecx
    467b:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4680:	89 c8                	mov    %ecx,%eax
    4682:	f7 ea                	imul   %edx
    4684:	c1 fa 02             	sar    $0x2,%edx
    4687:	89 c8                	mov    %ecx,%eax
    4689:	c1 f8 1f             	sar    $0x1f,%eax
    468c:	89 d1                	mov    %edx,%ecx
    468e:	29 c1                	sub    %eax,%ecx
    4690:	89 c8                	mov    %ecx,%eax
    4692:	83 c0 30             	add    $0x30,%eax
    4695:	88 45 a7             	mov    %al,-0x59(%ebp)
    4698:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    469b:	ba 67 66 66 66       	mov    $0x66666667,%edx
    46a0:	89 c8                	mov    %ecx,%eax
    46a2:	f7 ea                	imul   %edx
    46a4:	c1 fa 02             	sar    $0x2,%edx
    46a7:	89 c8                	mov    %ecx,%eax
    46a9:	c1 f8 1f             	sar    $0x1f,%eax
    46ac:	29 c2                	sub    %eax,%edx
    46ae:	89 d0                	mov    %edx,%eax
    46b0:	c1 e0 02             	shl    $0x2,%eax
    46b3:	01 d0                	add    %edx,%eax
    46b5:	01 c0                	add    %eax,%eax
    46b7:	89 ca                	mov    %ecx,%edx
    46b9:	29 c2                	sub    %eax,%edx
    46bb:	89 d0                	mov    %edx,%eax
    46bd:	83 c0 30             	add    $0x30,%eax
    46c0:	88 45 a8             	mov    %al,-0x58(%ebp)
    46c3:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    46c7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    46ca:	89 44 24 08          	mov    %eax,0x8(%esp)
    46ce:	c7 44 24 04 21 6a 00 	movl   $0x6a21,0x4(%esp)
    46d5:	00 
    46d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    46dd:	e8 d3 06 00 00       	call   4db5 <printf>
    46e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    46e9:	00 
    46ea:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    46ed:	89 04 24             	mov    %eax,(%esp)
    46f0:	e8 67 05 00 00       	call   4c5c <open>
    46f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    46f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    46fc:	79 1d                	jns    471b <fsfull+0x14b>
    46fe:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4701:	89 44 24 08          	mov    %eax,0x8(%esp)
    4705:	c7 44 24 04 2d 6a 00 	movl   $0x6a2d,0x4(%esp)
    470c:	00 
    470d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4714:	e8 9c 06 00 00       	call   4db5 <printf>
    4719:	eb 72                	jmp    478d <fsfull+0x1bd>
    471b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4722:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    4729:	00 
    472a:	c7 44 24 04 e0 92 00 	movl   $0x92e0,0x4(%esp)
    4731:	00 
    4732:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4735:	89 04 24             	mov    %eax,(%esp)
    4738:	e8 ff 04 00 00       	call   4c3c <write>
    473d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4740:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%ebp)
    4747:	7e 0c                	jle    4755 <fsfull+0x185>
    4749:	8b 45 f4             	mov    -0xc(%ebp),%eax
    474c:	01 45 f0             	add    %eax,-0x10(%ebp)
    474f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    4753:	eb cd                	jmp    4722 <fsfull+0x152>
    4755:	90                   	nop
    4756:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4759:	89 44 24 08          	mov    %eax,0x8(%esp)
    475d:	c7 44 24 04 3d 6a 00 	movl   $0x6a3d,0x4(%esp)
    4764:	00 
    4765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    476c:	e8 44 06 00 00       	call   4db5 <printf>
    4771:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4774:	89 04 24             	mov    %eax,(%esp)
    4777:	e8 c8 04 00 00       	call   4c44 <close>
    477c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4780:	75 02                	jne    4784 <fsfull+0x1b4>
    4782:	eb 09                	jmp    478d <fsfull+0x1bd>
    4784:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    4788:	e9 6c fe ff ff       	jmp    45f9 <fsfull+0x29>
    478d:	e9 dd 00 00 00       	jmp    486f <fsfull+0x29f>
    4792:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    4796:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    4799:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    479e:	89 c8                	mov    %ecx,%eax
    47a0:	f7 ea                	imul   %edx
    47a2:	c1 fa 06             	sar    $0x6,%edx
    47a5:	89 c8                	mov    %ecx,%eax
    47a7:	c1 f8 1f             	sar    $0x1f,%eax
    47aa:	89 d1                	mov    %edx,%ecx
    47ac:	29 c1                	sub    %eax,%ecx
    47ae:	89 c8                	mov    %ecx,%eax
    47b0:	83 c0 30             	add    $0x30,%eax
    47b3:	88 45 a5             	mov    %al,-0x5b(%ebp)
    47b6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    47b9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    47be:	89 d8                	mov    %ebx,%eax
    47c0:	f7 ea                	imul   %edx
    47c2:	c1 fa 06             	sar    $0x6,%edx
    47c5:	89 d8                	mov    %ebx,%eax
    47c7:	c1 f8 1f             	sar    $0x1f,%eax
    47ca:	89 d1                	mov    %edx,%ecx
    47cc:	29 c1                	sub    %eax,%ecx
    47ce:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    47d4:	89 d9                	mov    %ebx,%ecx
    47d6:	29 c1                	sub    %eax,%ecx
    47d8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    47dd:	89 c8                	mov    %ecx,%eax
    47df:	f7 ea                	imul   %edx
    47e1:	c1 fa 05             	sar    $0x5,%edx
    47e4:	89 c8                	mov    %ecx,%eax
    47e6:	c1 f8 1f             	sar    $0x1f,%eax
    47e9:	89 d1                	mov    %edx,%ecx
    47eb:	29 c1                	sub    %eax,%ecx
    47ed:	89 c8                	mov    %ecx,%eax
    47ef:	83 c0 30             	add    $0x30,%eax
    47f2:	88 45 a6             	mov    %al,-0x5a(%ebp)
    47f5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    47f8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    47fd:	89 d8                	mov    %ebx,%eax
    47ff:	f7 ea                	imul   %edx
    4801:	c1 fa 05             	sar    $0x5,%edx
    4804:	89 d8                	mov    %ebx,%eax
    4806:	c1 f8 1f             	sar    $0x1f,%eax
    4809:	89 d1                	mov    %edx,%ecx
    480b:	29 c1                	sub    %eax,%ecx
    480d:	6b c1 64             	imul   $0x64,%ecx,%eax
    4810:	89 d9                	mov    %ebx,%ecx
    4812:	29 c1                	sub    %eax,%ecx
    4814:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4819:	89 c8                	mov    %ecx,%eax
    481b:	f7 ea                	imul   %edx
    481d:	c1 fa 02             	sar    $0x2,%edx
    4820:	89 c8                	mov    %ecx,%eax
    4822:	c1 f8 1f             	sar    $0x1f,%eax
    4825:	89 d1                	mov    %edx,%ecx
    4827:	29 c1                	sub    %eax,%ecx
    4829:	89 c8                	mov    %ecx,%eax
    482b:	83 c0 30             	add    $0x30,%eax
    482e:	88 45 a7             	mov    %al,-0x59(%ebp)
    4831:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    4834:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4839:	89 c8                	mov    %ecx,%eax
    483b:	f7 ea                	imul   %edx
    483d:	c1 fa 02             	sar    $0x2,%edx
    4840:	89 c8                	mov    %ecx,%eax
    4842:	c1 f8 1f             	sar    $0x1f,%eax
    4845:	29 c2                	sub    %eax,%edx
    4847:	89 d0                	mov    %edx,%eax
    4849:	c1 e0 02             	shl    $0x2,%eax
    484c:	01 d0                	add    %edx,%eax
    484e:	01 c0                	add    %eax,%eax
    4850:	89 ca                	mov    %ecx,%edx
    4852:	29 c2                	sub    %eax,%edx
    4854:	89 d0                	mov    %edx,%eax
    4856:	83 c0 30             	add    $0x30,%eax
    4859:	88 45 a8             	mov    %al,-0x58(%ebp)
    485c:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    4860:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4863:	89 04 24             	mov    %eax,(%esp)
    4866:	e8 01 04 00 00       	call   4c6c <unlink>
    486b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
    486f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    4873:	0f 89 19 ff ff ff    	jns    4792 <fsfull+0x1c2>
    4879:	c7 44 24 04 4d 6a 00 	movl   $0x6a4d,0x4(%esp)
    4880:	00 
    4881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4888:	e8 28 05 00 00       	call   4db5 <printf>
    488d:	83 c4 74             	add    $0x74,%esp
    4890:	5b                   	pop    %ebx
    4891:	5d                   	pop    %ebp
    4892:	c3                   	ret    

00004893 <rand>:
    4893:	55                   	push   %ebp
    4894:	89 e5                	mov    %esp,%ebp
    4896:	a1 00 6b 00 00       	mov    0x6b00,%eax
    489b:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    48a1:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    48a6:	a3 00 6b 00 00       	mov    %eax,0x6b00
    48ab:	a1 00 6b 00 00       	mov    0x6b00,%eax
    48b0:	5d                   	pop    %ebp
    48b1:	c3                   	ret    

000048b2 <main>:
    48b2:	55                   	push   %ebp
    48b3:	89 e5                	mov    %esp,%ebp
    48b5:	83 e4 f0             	and    $0xfffffff0,%esp
    48b8:	83 ec 10             	sub    $0x10,%esp
    48bb:	c7 44 24 04 63 6a 00 	movl   $0x6a63,0x4(%esp)
    48c2:	00 
    48c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    48ca:	e8 e6 04 00 00       	call   4db5 <printf>
    48cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    48d6:	00 
    48d7:	c7 04 24 77 6a 00 00 	movl   $0x6a77,(%esp)
    48de:	e8 79 03 00 00       	call   4c5c <open>
    48e3:	85 c0                	test   %eax,%eax
    48e5:	78 19                	js     4900 <main+0x4e>
    48e7:	c7 44 24 04 88 6a 00 	movl   $0x6a88,0x4(%esp)
    48ee:	00 
    48ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    48f6:	e8 ba 04 00 00       	call   4db5 <printf>
    48fb:	e8 1c 03 00 00       	call   4c1c <exit>
    4900:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    4907:	00 
    4908:	c7 04 24 77 6a 00 00 	movl   $0x6a77,(%esp)
    490f:	e8 48 03 00 00       	call   4c5c <open>
    4914:	89 04 24             	mov    %eax,(%esp)
    4917:	e8 28 03 00 00       	call   4c44 <close>
    491c:	e8 86 fb ff ff       	call   44a7 <bigargtest>
    4921:	e8 f1 ea ff ff       	call   3417 <bigwrite>
    4926:	e8 7c fb ff ff       	call   44a7 <bigargtest>
    492b:	e8 06 fb ff ff       	call   4436 <bsstest>
    4930:	e8 1c f5 ff ff       	call   3e51 <sbrktest>
    4935:	e8 2f fa ff ff       	call   4369 <validatetest>
    493a:	e8 c1 c6 ff ff       	call   1000 <opentest>
    493f:	e8 67 c7 ff ff       	call   10ab <writetest>
    4944:	e8 77 c9 ff ff       	call   12c0 <writetest1>
    4949:	e8 7b cb ff ff       	call   14c9 <createtest>
    494e:	e8 19 d1 ff ff       	call   1a6c <mem>
    4953:	e8 52 cd ff ff       	call   16aa <pipe1>
    4958:	e8 38 cf ff ff       	call   1895 <preempt>
    495d:	e8 8c d0 ff ff       	call   19ee <exitwait>
    4962:	e8 39 ef ff ff       	call   38a0 <rmdot>
    4967:	e8 de ed ff ff       	call   374a <fourteen>
    496c:	e8 ae eb ff ff       	call   351f <bigfile>
    4971:	e8 5b e3 ff ff       	call   2cd1 <subdir>
    4976:	e8 06 dd ff ff       	call   2681 <concreate>
    497b:	e8 b0 e0 ff ff       	call   2a30 <linkunlink>
    4980:	e8 b3 da ff ff       	call   2438 <linktest>
    4985:	e8 d9 d8 ff ff       	call   2263 <unlinkread>
    498a:	e8 22 d6 ff ff       	call   1fb1 <createdelete>
    498f:	e8 b6 d3 ff ff       	call   1d4a <twofiles>
    4994:	e8 b8 d1 ff ff       	call   1b51 <sharedfd>
    4999:	e8 7a f0 ff ff       	call   3a18 <dirfile>
    499e:	e8 b7 f2 ff ff       	call   3c5a <iref>
    49a3:	e8 d6 f3 ff ff       	call   3d7e <forktest>
    49a8:	e8 af e1 ff ff       	call   2b5c <bigdir>
    49ad:	e8 a9 cc ff ff       	call   165b <exectest>
    49b2:	e8 65 02 00 00       	call   4c1c <exit>
    49b7:	90                   	nop

000049b8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    49b8:	55                   	push   %ebp
    49b9:	89 e5                	mov    %esp,%ebp
    49bb:	57                   	push   %edi
    49bc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    49bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    49c0:	8b 55 10             	mov    0x10(%ebp),%edx
    49c3:	8b 45 0c             	mov    0xc(%ebp),%eax
    49c6:	89 cb                	mov    %ecx,%ebx
    49c8:	89 df                	mov    %ebx,%edi
    49ca:	89 d1                	mov    %edx,%ecx
    49cc:	fc                   	cld    
    49cd:	f3 aa                	rep stos %al,%es:(%edi)
    49cf:	89 ca                	mov    %ecx,%edx
    49d1:	89 fb                	mov    %edi,%ebx
    49d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
    49d6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    49d9:	5b                   	pop    %ebx
    49da:	5f                   	pop    %edi
    49db:	5d                   	pop    %ebp
    49dc:	c3                   	ret    

000049dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    49dd:	55                   	push   %ebp
    49de:	89 e5                	mov    %esp,%ebp
    49e0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    49e3:	8b 45 08             	mov    0x8(%ebp),%eax
    49e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    49e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    49ec:	0f b6 10             	movzbl (%eax),%edx
    49ef:	8b 45 08             	mov    0x8(%ebp),%eax
    49f2:	88 10                	mov    %dl,(%eax)
    49f4:	8b 45 08             	mov    0x8(%ebp),%eax
    49f7:	0f b6 00             	movzbl (%eax),%eax
    49fa:	84 c0                	test   %al,%al
    49fc:	0f 95 c0             	setne  %al
    49ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4a03:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    4a07:	84 c0                	test   %al,%al
    4a09:	75 de                	jne    49e9 <strcpy+0xc>
    ;
  return os;
    4a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4a0e:	c9                   	leave  
    4a0f:	c3                   	ret    

00004a10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a10:	55                   	push   %ebp
    4a11:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    4a13:	eb 08                	jmp    4a1d <strcmp+0xd>
    p++, q++;
    4a15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4a19:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    4a1d:	8b 45 08             	mov    0x8(%ebp),%eax
    4a20:	0f b6 00             	movzbl (%eax),%eax
    4a23:	84 c0                	test   %al,%al
    4a25:	74 10                	je     4a37 <strcmp+0x27>
    4a27:	8b 45 08             	mov    0x8(%ebp),%eax
    4a2a:	0f b6 10             	movzbl (%eax),%edx
    4a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a30:	0f b6 00             	movzbl (%eax),%eax
    4a33:	38 c2                	cmp    %al,%dl
    4a35:	74 de                	je     4a15 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    4a37:	8b 45 08             	mov    0x8(%ebp),%eax
    4a3a:	0f b6 00             	movzbl (%eax),%eax
    4a3d:	0f b6 d0             	movzbl %al,%edx
    4a40:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a43:	0f b6 00             	movzbl (%eax),%eax
    4a46:	0f b6 c0             	movzbl %al,%eax
    4a49:	89 d1                	mov    %edx,%ecx
    4a4b:	29 c1                	sub    %eax,%ecx
    4a4d:	89 c8                	mov    %ecx,%eax
}
    4a4f:	5d                   	pop    %ebp
    4a50:	c3                   	ret    

00004a51 <strlen>:

uint
strlen(char *s)
{
    4a51:	55                   	push   %ebp
    4a52:	89 e5                	mov    %esp,%ebp
    4a54:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    4a57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    4a5e:	eb 04                	jmp    4a64 <strlen+0x13>
    4a60:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    4a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4a67:	03 45 08             	add    0x8(%ebp),%eax
    4a6a:	0f b6 00             	movzbl (%eax),%eax
    4a6d:	84 c0                	test   %al,%al
    4a6f:	75 ef                	jne    4a60 <strlen+0xf>
    ;
  return n;
    4a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4a74:	c9                   	leave  
    4a75:	c3                   	ret    

00004a76 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4a76:	55                   	push   %ebp
    4a77:	89 e5                	mov    %esp,%ebp
    4a79:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    4a7c:	8b 45 10             	mov    0x10(%ebp),%eax
    4a7f:	89 44 24 08          	mov    %eax,0x8(%esp)
    4a83:	8b 45 0c             	mov    0xc(%ebp),%eax
    4a86:	89 44 24 04          	mov    %eax,0x4(%esp)
    4a8a:	8b 45 08             	mov    0x8(%ebp),%eax
    4a8d:	89 04 24             	mov    %eax,(%esp)
    4a90:	e8 23 ff ff ff       	call   49b8 <stosb>
  return dst;
    4a95:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4a98:	c9                   	leave  
    4a99:	c3                   	ret    

00004a9a <strchr>:

char*
strchr(const char *s, char c)
{
    4a9a:	55                   	push   %ebp
    4a9b:	89 e5                	mov    %esp,%ebp
    4a9d:	83 ec 04             	sub    $0x4,%esp
    4aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
    4aa3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    4aa6:	eb 14                	jmp    4abc <strchr+0x22>
    if(*s == c)
    4aa8:	8b 45 08             	mov    0x8(%ebp),%eax
    4aab:	0f b6 00             	movzbl (%eax),%eax
    4aae:	3a 45 fc             	cmp    -0x4(%ebp),%al
    4ab1:	75 05                	jne    4ab8 <strchr+0x1e>
      return (char*)s;
    4ab3:	8b 45 08             	mov    0x8(%ebp),%eax
    4ab6:	eb 13                	jmp    4acb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    4ab8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4abc:	8b 45 08             	mov    0x8(%ebp),%eax
    4abf:	0f b6 00             	movzbl (%eax),%eax
    4ac2:	84 c0                	test   %al,%al
    4ac4:	75 e2                	jne    4aa8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    4ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
    4acb:	c9                   	leave  
    4acc:	c3                   	ret    

00004acd <gets>:

char*
gets(char *buf, int max)
{
    4acd:	55                   	push   %ebp
    4ace:	89 e5                	mov    %esp,%ebp
    4ad0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4ad3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4ada:	eb 44                	jmp    4b20 <gets+0x53>
    cc = read(0, &c, 1);
    4adc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4ae3:	00 
    4ae4:	8d 45 ef             	lea    -0x11(%ebp),%eax
    4ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
    4aeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4af2:	e8 3d 01 00 00       	call   4c34 <read>
    4af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
    4afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4afe:	7e 2d                	jle    4b2d <gets+0x60>
      break;
    buf[i++] = c;
    4b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4b03:	03 45 08             	add    0x8(%ebp),%eax
    4b06:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
    4b0a:	88 10                	mov    %dl,(%eax)
    4b0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
    4b10:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4b14:	3c 0a                	cmp    $0xa,%al
    4b16:	74 16                	je     4b2e <gets+0x61>
    4b18:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4b1c:	3c 0d                	cmp    $0xd,%al
    4b1e:	74 0e                	je     4b2e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4b23:	83 c0 01             	add    $0x1,%eax
    4b26:	3b 45 0c             	cmp    0xc(%ebp),%eax
    4b29:	7c b1                	jl     4adc <gets+0xf>
    4b2b:	eb 01                	jmp    4b2e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    4b2d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    4b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4b31:	03 45 08             	add    0x8(%ebp),%eax
    4b34:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    4b37:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4b3a:	c9                   	leave  
    4b3b:	c3                   	ret    

00004b3c <stat>:

int
stat(char *n, struct stat *st)
{
    4b3c:	55                   	push   %ebp
    4b3d:	89 e5                	mov    %esp,%ebp
    4b3f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4b42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4b49:	00 
    4b4a:	8b 45 08             	mov    0x8(%ebp),%eax
    4b4d:	89 04 24             	mov    %eax,(%esp)
    4b50:	e8 07 01 00 00       	call   4c5c <open>
    4b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
    4b58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4b5c:	79 07                	jns    4b65 <stat+0x29>
    return -1;
    4b5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    4b63:	eb 23                	jmp    4b88 <stat+0x4c>
  r = fstat(fd, st);
    4b65:	8b 45 0c             	mov    0xc(%ebp),%eax
    4b68:	89 44 24 04          	mov    %eax,0x4(%esp)
    4b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4b6f:	89 04 24             	mov    %eax,(%esp)
    4b72:	e8 fd 00 00 00       	call   4c74 <fstat>
    4b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
    4b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4b7d:	89 04 24             	mov    %eax,(%esp)
    4b80:	e8 bf 00 00 00       	call   4c44 <close>
  return r;
    4b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    4b88:	c9                   	leave  
    4b89:	c3                   	ret    

00004b8a <atoi>:

int
atoi(const char *s)
{
    4b8a:	55                   	push   %ebp
    4b8b:	89 e5                	mov    %esp,%ebp
    4b8d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    4b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4b97:	eb 24                	jmp    4bbd <atoi+0x33>
    n = n*10 + *s++ - '0';
    4b99:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4b9c:	89 d0                	mov    %edx,%eax
    4b9e:	c1 e0 02             	shl    $0x2,%eax
    4ba1:	01 d0                	add    %edx,%eax
    4ba3:	01 c0                	add    %eax,%eax
    4ba5:	89 c2                	mov    %eax,%edx
    4ba7:	8b 45 08             	mov    0x8(%ebp),%eax
    4baa:	0f b6 00             	movzbl (%eax),%eax
    4bad:	0f be c0             	movsbl %al,%eax
    4bb0:	8d 04 02             	lea    (%edx,%eax,1),%eax
    4bb3:	83 e8 30             	sub    $0x30,%eax
    4bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4bb9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4bbd:	8b 45 08             	mov    0x8(%ebp),%eax
    4bc0:	0f b6 00             	movzbl (%eax),%eax
    4bc3:	3c 2f                	cmp    $0x2f,%al
    4bc5:	7e 0a                	jle    4bd1 <atoi+0x47>
    4bc7:	8b 45 08             	mov    0x8(%ebp),%eax
    4bca:	0f b6 00             	movzbl (%eax),%eax
    4bcd:	3c 39                	cmp    $0x39,%al
    4bcf:	7e c8                	jle    4b99 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    4bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4bd4:	c9                   	leave  
    4bd5:	c3                   	ret    

00004bd6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    4bd6:	55                   	push   %ebp
    4bd7:	89 e5                	mov    %esp,%ebp
    4bd9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    4bdc:	8b 45 08             	mov    0x8(%ebp),%eax
    4bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
    4be2:	8b 45 0c             	mov    0xc(%ebp),%eax
    4be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
    4be8:	eb 13                	jmp    4bfd <memmove+0x27>
    *dst++ = *src++;
    4bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4bed:	0f b6 10             	movzbl (%eax),%edx
    4bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4bf3:	88 10                	mov    %dl,(%eax)
    4bf5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    4bf9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4bfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    4c01:	0f 9f c0             	setg   %al
    4c04:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    4c08:	84 c0                	test   %al,%al
    4c0a:	75 de                	jne    4bea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    4c0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4c0f:	c9                   	leave  
    4c10:	c3                   	ret    
    4c11:	90                   	nop
    4c12:	90                   	nop
    4c13:	90                   	nop

00004c14 <fork>:
    4c14:	b8 01 00 00 00       	mov    $0x1,%eax
    4c19:	cd 40                	int    $0x40
    4c1b:	c3                   	ret    

00004c1c <exit>:
    4c1c:	b8 02 00 00 00       	mov    $0x2,%eax
    4c21:	cd 40                	int    $0x40
    4c23:	c3                   	ret    

00004c24 <wait>:
    4c24:	b8 03 00 00 00       	mov    $0x3,%eax
    4c29:	cd 40                	int    $0x40
    4c2b:	c3                   	ret    

00004c2c <pipe>:
    4c2c:	b8 04 00 00 00       	mov    $0x4,%eax
    4c31:	cd 40                	int    $0x40
    4c33:	c3                   	ret    

00004c34 <read>:
    4c34:	b8 05 00 00 00       	mov    $0x5,%eax
    4c39:	cd 40                	int    $0x40
    4c3b:	c3                   	ret    

00004c3c <write>:
    4c3c:	b8 10 00 00 00       	mov    $0x10,%eax
    4c41:	cd 40                	int    $0x40
    4c43:	c3                   	ret    

00004c44 <close>:
    4c44:	b8 15 00 00 00       	mov    $0x15,%eax
    4c49:	cd 40                	int    $0x40
    4c4b:	c3                   	ret    

00004c4c <kill>:
    4c4c:	b8 06 00 00 00       	mov    $0x6,%eax
    4c51:	cd 40                	int    $0x40
    4c53:	c3                   	ret    

00004c54 <exec>:
    4c54:	b8 07 00 00 00       	mov    $0x7,%eax
    4c59:	cd 40                	int    $0x40
    4c5b:	c3                   	ret    

00004c5c <open>:
    4c5c:	b8 0f 00 00 00       	mov    $0xf,%eax
    4c61:	cd 40                	int    $0x40
    4c63:	c3                   	ret    

00004c64 <mknod>:
    4c64:	b8 11 00 00 00       	mov    $0x11,%eax
    4c69:	cd 40                	int    $0x40
    4c6b:	c3                   	ret    

00004c6c <unlink>:
    4c6c:	b8 12 00 00 00       	mov    $0x12,%eax
    4c71:	cd 40                	int    $0x40
    4c73:	c3                   	ret    

00004c74 <fstat>:
    4c74:	b8 08 00 00 00       	mov    $0x8,%eax
    4c79:	cd 40                	int    $0x40
    4c7b:	c3                   	ret    

00004c7c <link>:
    4c7c:	b8 13 00 00 00       	mov    $0x13,%eax
    4c81:	cd 40                	int    $0x40
    4c83:	c3                   	ret    

00004c84 <mkdir>:
    4c84:	b8 14 00 00 00       	mov    $0x14,%eax
    4c89:	cd 40                	int    $0x40
    4c8b:	c3                   	ret    

00004c8c <chdir>:
    4c8c:	b8 09 00 00 00       	mov    $0x9,%eax
    4c91:	cd 40                	int    $0x40
    4c93:	c3                   	ret    

00004c94 <dup>:
    4c94:	b8 0a 00 00 00       	mov    $0xa,%eax
    4c99:	cd 40                	int    $0x40
    4c9b:	c3                   	ret    

00004c9c <getpid>:
    4c9c:	b8 0b 00 00 00       	mov    $0xb,%eax
    4ca1:	cd 40                	int    $0x40
    4ca3:	c3                   	ret    

00004ca4 <sbrk>:
    4ca4:	b8 0c 00 00 00       	mov    $0xc,%eax
    4ca9:	cd 40                	int    $0x40
    4cab:	c3                   	ret    

00004cac <sleep>:
    4cac:	b8 0d 00 00 00       	mov    $0xd,%eax
    4cb1:	cd 40                	int    $0x40
    4cb3:	c3                   	ret    

00004cb4 <uptime>:
    4cb4:	b8 0e 00 00 00       	mov    $0xe,%eax
    4cb9:	cd 40                	int    $0x40
    4cbb:	c3                   	ret    

00004cbc <clone>:
    4cbc:	b8 16 00 00 00       	mov    $0x16,%eax
    4cc1:	cd 40                	int    $0x40
    4cc3:	c3                   	ret    

00004cc4 <texit>:
    4cc4:	b8 17 00 00 00       	mov    $0x17,%eax
    4cc9:	cd 40                	int    $0x40
    4ccb:	c3                   	ret    

00004ccc <tsleep>:
    4ccc:	b8 18 00 00 00       	mov    $0x18,%eax
    4cd1:	cd 40                	int    $0x40
    4cd3:	c3                   	ret    

00004cd4 <twakeup>:
    4cd4:	b8 19 00 00 00       	mov    $0x19,%eax
    4cd9:	cd 40                	int    $0x40
    4cdb:	c3                   	ret    

00004cdc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    4cdc:	55                   	push   %ebp
    4cdd:	89 e5                	mov    %esp,%ebp
    4cdf:	83 ec 28             	sub    $0x28,%esp
    4ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
    4ce5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    4ce8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4cef:	00 
    4cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    4cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
    4cf7:	8b 45 08             	mov    0x8(%ebp),%eax
    4cfa:	89 04 24             	mov    %eax,(%esp)
    4cfd:	e8 3a ff ff ff       	call   4c3c <write>
}
    4d02:	c9                   	leave  
    4d03:	c3                   	ret    

00004d04 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4d04:	55                   	push   %ebp
    4d05:	89 e5                	mov    %esp,%ebp
    4d07:	53                   	push   %ebx
    4d08:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    4d0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    4d12:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    4d16:	74 17                	je     4d2f <printint+0x2b>
    4d18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    4d1c:	79 11                	jns    4d2f <printint+0x2b>
    neg = 1;
    4d1e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    4d25:	8b 45 0c             	mov    0xc(%ebp),%eax
    4d28:	f7 d8                	neg    %eax
    4d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4d2d:	eb 06                	jmp    4d35 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
    4d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
    4d35:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
    4d3c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    4d3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    4d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4d45:	ba 00 00 00 00       	mov    $0x0,%edx
    4d4a:	f7 f3                	div    %ebx
    4d4c:	89 d0                	mov    %edx,%eax
    4d4e:	0f b6 80 04 6b 00 00 	movzbl 0x6b04(%eax),%eax
    4d55:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
    4d59:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
    4d5d:	8b 45 10             	mov    0x10(%ebp),%eax
    4d60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    4d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4d66:	ba 00 00 00 00       	mov    $0x0,%edx
    4d6b:	f7 75 d4             	divl   -0x2c(%ebp)
    4d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4d75:	75 c5                	jne    4d3c <printint+0x38>
  if(neg)
    4d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4d7b:	74 28                	je     4da5 <printint+0xa1>
    buf[i++] = '-';
    4d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4d80:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
    4d85:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
    4d89:	eb 1a                	jmp    4da5 <printint+0xa1>
    putc(fd, buf[i]);
    4d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4d8e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
    4d93:	0f be c0             	movsbl %al,%eax
    4d96:	89 44 24 04          	mov    %eax,0x4(%esp)
    4d9a:	8b 45 08             	mov    0x8(%ebp),%eax
    4d9d:	89 04 24             	mov    %eax,(%esp)
    4da0:	e8 37 ff ff ff       	call   4cdc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4da5:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
    4da9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4dad:	79 dc                	jns    4d8b <printint+0x87>
    putc(fd, buf[i]);
}
    4daf:	83 c4 44             	add    $0x44,%esp
    4db2:	5b                   	pop    %ebx
    4db3:	5d                   	pop    %ebp
    4db4:	c3                   	ret    

00004db5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4db5:	55                   	push   %ebp
    4db6:	89 e5                	mov    %esp,%ebp
    4db8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4dbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4dc2:	8d 45 0c             	lea    0xc(%ebp),%eax
    4dc5:	83 c0 04             	add    $0x4,%eax
    4dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
    4dcb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    4dd2:	e9 7e 01 00 00       	jmp    4f55 <printf+0x1a0>
    c = fmt[i] & 0xff;
    4dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
    4dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4ddd:	8d 04 02             	lea    (%edx,%eax,1),%eax
    4de0:	0f b6 00             	movzbl (%eax),%eax
    4de3:	0f be c0             	movsbl %al,%eax
    4de6:	25 ff 00 00 00       	and    $0xff,%eax
    4deb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
    4dee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4df2:	75 2c                	jne    4e20 <printf+0x6b>
      if(c == '%'){
    4df4:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    4df8:	75 0c                	jne    4e06 <printf+0x51>
        state = '%';
    4dfa:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
    4e01:	e9 4b 01 00 00       	jmp    4f51 <printf+0x19c>
      } else {
        putc(fd, c);
    4e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4e09:	0f be c0             	movsbl %al,%eax
    4e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e10:	8b 45 08             	mov    0x8(%ebp),%eax
    4e13:	89 04 24             	mov    %eax,(%esp)
    4e16:	e8 c1 fe ff ff       	call   4cdc <putc>
    4e1b:	e9 31 01 00 00       	jmp    4f51 <printf+0x19c>
      }
    } else if(state == '%'){
    4e20:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
    4e24:	0f 85 27 01 00 00    	jne    4f51 <printf+0x19c>
      if(c == 'd'){
    4e2a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
    4e2e:	75 2d                	jne    4e5d <printf+0xa8>
        printint(fd, *ap, 10, 1);
    4e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4e33:	8b 00                	mov    (%eax),%eax
    4e35:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    4e3c:	00 
    4e3d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    4e44:	00 
    4e45:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e49:	8b 45 08             	mov    0x8(%ebp),%eax
    4e4c:	89 04 24             	mov    %eax,(%esp)
    4e4f:	e8 b0 fe ff ff       	call   4d04 <printint>
        ap++;
    4e54:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    4e58:	e9 ed 00 00 00       	jmp    4f4a <printf+0x195>
      } else if(c == 'x' || c == 'p'){
    4e5d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
    4e61:	74 06                	je     4e69 <printf+0xb4>
    4e63:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
    4e67:	75 2d                	jne    4e96 <printf+0xe1>
        printint(fd, *ap, 16, 0);
    4e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4e6c:	8b 00                	mov    (%eax),%eax
    4e6e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    4e75:	00 
    4e76:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    4e7d:	00 
    4e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e82:	8b 45 08             	mov    0x8(%ebp),%eax
    4e85:	89 04 24             	mov    %eax,(%esp)
    4e88:	e8 77 fe ff ff       	call   4d04 <printint>
        ap++;
    4e8d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    4e91:	e9 b4 00 00 00       	jmp    4f4a <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    4e96:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
    4e9a:	75 46                	jne    4ee2 <printf+0x12d>
        s = (char*)*ap;
    4e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4e9f:	8b 00                	mov    (%eax),%eax
    4ea1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
    4ea4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
    4ea8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    4eac:	75 27                	jne    4ed5 <printf+0x120>
          s = "(null)";
    4eae:	c7 45 e4 b2 6a 00 00 	movl   $0x6ab2,-0x1c(%ebp)
        while(*s != 0){
    4eb5:	eb 1f                	jmp    4ed6 <printf+0x121>
          putc(fd, *s);
    4eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4eba:	0f b6 00             	movzbl (%eax),%eax
    4ebd:	0f be c0             	movsbl %al,%eax
    4ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
    4ec4:	8b 45 08             	mov    0x8(%ebp),%eax
    4ec7:	89 04 24             	mov    %eax,(%esp)
    4eca:	e8 0d fe ff ff       	call   4cdc <putc>
          s++;
    4ecf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    4ed3:	eb 01                	jmp    4ed6 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4ed5:	90                   	nop
    4ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4ed9:	0f b6 00             	movzbl (%eax),%eax
    4edc:	84 c0                	test   %al,%al
    4ede:	75 d7                	jne    4eb7 <printf+0x102>
    4ee0:	eb 68                	jmp    4f4a <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4ee2:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
    4ee6:	75 1d                	jne    4f05 <printf+0x150>
        putc(fd, *ap);
    4ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4eeb:	8b 00                	mov    (%eax),%eax
    4eed:	0f be c0             	movsbl %al,%eax
    4ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
    4ef4:	8b 45 08             	mov    0x8(%ebp),%eax
    4ef7:	89 04 24             	mov    %eax,(%esp)
    4efa:	e8 dd fd ff ff       	call   4cdc <putc>
        ap++;
    4eff:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    4f03:	eb 45                	jmp    4f4a <printf+0x195>
      } else if(c == '%'){
    4f05:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    4f09:	75 17                	jne    4f22 <printf+0x16d>
        putc(fd, c);
    4f0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4f0e:	0f be c0             	movsbl %al,%eax
    4f11:	89 44 24 04          	mov    %eax,0x4(%esp)
    4f15:	8b 45 08             	mov    0x8(%ebp),%eax
    4f18:	89 04 24             	mov    %eax,(%esp)
    4f1b:	e8 bc fd ff ff       	call   4cdc <putc>
    4f20:	eb 28                	jmp    4f4a <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4f22:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    4f29:	00 
    4f2a:	8b 45 08             	mov    0x8(%ebp),%eax
    4f2d:	89 04 24             	mov    %eax,(%esp)
    4f30:	e8 a7 fd ff ff       	call   4cdc <putc>
        putc(fd, c);
    4f35:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4f38:	0f be c0             	movsbl %al,%eax
    4f3b:	89 44 24 04          	mov    %eax,0x4(%esp)
    4f3f:	8b 45 08             	mov    0x8(%ebp),%eax
    4f42:	89 04 24             	mov    %eax,(%esp)
    4f45:	e8 92 fd ff ff       	call   4cdc <putc>
      }
      state = 0;
    4f4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4f51:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    4f55:	8b 55 0c             	mov    0xc(%ebp),%edx
    4f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4f5b:	8d 04 02             	lea    (%edx,%eax,1),%eax
    4f5e:	0f b6 00             	movzbl (%eax),%eax
    4f61:	84 c0                	test   %al,%al
    4f63:	0f 85 6e fe ff ff    	jne    4dd7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4f69:	c9                   	leave  
    4f6a:	c3                   	ret    
    4f6b:	90                   	nop

00004f6c <free>:
    4f6c:	55                   	push   %ebp
    4f6d:	89 e5                	mov    %esp,%ebp
    4f6f:	83 ec 10             	sub    $0x10,%esp
    4f72:	8b 45 08             	mov    0x8(%ebp),%eax
    4f75:	83 e8 08             	sub    $0x8,%eax
    4f78:	89 45 f8             	mov    %eax,-0x8(%ebp)
    4f7b:	a1 a8 6b 00 00       	mov    0x6ba8,%eax
    4f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4f83:	eb 24                	jmp    4fa9 <free+0x3d>
    4f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4f88:	8b 00                	mov    (%eax),%eax
    4f8a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4f8d:	77 12                	ja     4fa1 <free+0x35>
    4f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4f92:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4f95:	77 24                	ja     4fbb <free+0x4f>
    4f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4f9a:	8b 00                	mov    (%eax),%eax
    4f9c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4f9f:	77 1a                	ja     4fbb <free+0x4f>
    4fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fa4:	8b 00                	mov    (%eax),%eax
    4fa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4faf:	76 d4                	jbe    4f85 <free+0x19>
    4fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fb4:	8b 00                	mov    (%eax),%eax
    4fb6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4fb9:	76 ca                	jbe    4f85 <free+0x19>
    4fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fbe:	8b 40 04             	mov    0x4(%eax),%eax
    4fc1:	c1 e0 03             	shl    $0x3,%eax
    4fc4:	89 c2                	mov    %eax,%edx
    4fc6:	03 55 f8             	add    -0x8(%ebp),%edx
    4fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fcc:	8b 00                	mov    (%eax),%eax
    4fce:	39 c2                	cmp    %eax,%edx
    4fd0:	75 24                	jne    4ff6 <free+0x8a>
    4fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fd5:	8b 50 04             	mov    0x4(%eax),%edx
    4fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fdb:	8b 00                	mov    (%eax),%eax
    4fdd:	8b 40 04             	mov    0x4(%eax),%eax
    4fe0:	01 c2                	add    %eax,%edx
    4fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4fe5:	89 50 04             	mov    %edx,0x4(%eax)
    4fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4feb:	8b 00                	mov    (%eax),%eax
    4fed:	8b 10                	mov    (%eax),%edx
    4fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4ff2:	89 10                	mov    %edx,(%eax)
    4ff4:	eb 0a                	jmp    5000 <free+0x94>
    4ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4ff9:	8b 10                	mov    (%eax),%edx
    4ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4ffe:	89 10                	mov    %edx,(%eax)
    5000:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5003:	8b 40 04             	mov    0x4(%eax),%eax
    5006:	c1 e0 03             	shl    $0x3,%eax
    5009:	03 45 fc             	add    -0x4(%ebp),%eax
    500c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    500f:	75 20                	jne    5031 <free+0xc5>
    5011:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5014:	8b 50 04             	mov    0x4(%eax),%edx
    5017:	8b 45 f8             	mov    -0x8(%ebp),%eax
    501a:	8b 40 04             	mov    0x4(%eax),%eax
    501d:	01 c2                	add    %eax,%edx
    501f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5022:	89 50 04             	mov    %edx,0x4(%eax)
    5025:	8b 45 f8             	mov    -0x8(%ebp),%eax
    5028:	8b 10                	mov    (%eax),%edx
    502a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    502d:	89 10                	mov    %edx,(%eax)
    502f:	eb 08                	jmp    5039 <free+0xcd>
    5031:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5034:	8b 55 f8             	mov    -0x8(%ebp),%edx
    5037:	89 10                	mov    %edx,(%eax)
    5039:	8b 45 fc             	mov    -0x4(%ebp),%eax
    503c:	a3 a8 6b 00 00       	mov    %eax,0x6ba8
    5041:	c9                   	leave  
    5042:	c3                   	ret    

00005043 <morecore>:
    5043:	55                   	push   %ebp
    5044:	89 e5                	mov    %esp,%ebp
    5046:	83 ec 28             	sub    $0x28,%esp
    5049:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    5050:	77 07                	ja     5059 <morecore+0x16>
    5052:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
    5059:	8b 45 08             	mov    0x8(%ebp),%eax
    505c:	c1 e0 03             	shl    $0x3,%eax
    505f:	89 04 24             	mov    %eax,(%esp)
    5062:	e8 3d fc ff ff       	call   4ca4 <sbrk>
    5067:	89 45 f0             	mov    %eax,-0x10(%ebp)
    506a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    506e:	75 07                	jne    5077 <morecore+0x34>
    5070:	b8 00 00 00 00       	mov    $0x0,%eax
    5075:	eb 22                	jmp    5099 <morecore+0x56>
    5077:	8b 45 f0             	mov    -0x10(%ebp),%eax
    507a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    507d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5080:	8b 55 08             	mov    0x8(%ebp),%edx
    5083:	89 50 04             	mov    %edx,0x4(%eax)
    5086:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5089:	83 c0 08             	add    $0x8,%eax
    508c:	89 04 24             	mov    %eax,(%esp)
    508f:	e8 d8 fe ff ff       	call   4f6c <free>
    5094:	a1 a8 6b 00 00       	mov    0x6ba8,%eax
    5099:	c9                   	leave  
    509a:	c3                   	ret    

0000509b <malloc>:
    509b:	55                   	push   %ebp
    509c:	89 e5                	mov    %esp,%ebp
    509e:	83 ec 28             	sub    $0x28,%esp
    50a1:	8b 45 08             	mov    0x8(%ebp),%eax
    50a4:	83 c0 07             	add    $0x7,%eax
    50a7:	c1 e8 03             	shr    $0x3,%eax
    50aa:	83 c0 01             	add    $0x1,%eax
    50ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    50b0:	a1 a8 6b 00 00       	mov    0x6ba8,%eax
    50b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    50b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    50bc:	75 23                	jne    50e1 <malloc+0x46>
    50be:	c7 45 f0 a0 6b 00 00 	movl   $0x6ba0,-0x10(%ebp)
    50c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    50c8:	a3 a8 6b 00 00       	mov    %eax,0x6ba8
    50cd:	a1 a8 6b 00 00       	mov    0x6ba8,%eax
    50d2:	a3 a0 6b 00 00       	mov    %eax,0x6ba0
    50d7:	c7 05 a4 6b 00 00 00 	movl   $0x0,0x6ba4
    50de:	00 00 00 
    50e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    50e4:	8b 00                	mov    (%eax),%eax
    50e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    50e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    50ec:	8b 40 04             	mov    0x4(%eax),%eax
    50ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    50f2:	72 4d                	jb     5141 <malloc+0xa6>
    50f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    50f7:	8b 40 04             	mov    0x4(%eax),%eax
    50fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    50fd:	75 0c                	jne    510b <malloc+0x70>
    50ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
    5102:	8b 10                	mov    (%eax),%edx
    5104:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5107:	89 10                	mov    %edx,(%eax)
    5109:	eb 26                	jmp    5131 <malloc+0x96>
    510b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    510e:	8b 40 04             	mov    0x4(%eax),%eax
    5111:	89 c2                	mov    %eax,%edx
    5113:	2b 55 f4             	sub    -0xc(%ebp),%edx
    5116:	8b 45 ec             	mov    -0x14(%ebp),%eax
    5119:	89 50 04             	mov    %edx,0x4(%eax)
    511c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    511f:	8b 40 04             	mov    0x4(%eax),%eax
    5122:	c1 e0 03             	shl    $0x3,%eax
    5125:	01 45 ec             	add    %eax,-0x14(%ebp)
    5128:	8b 45 ec             	mov    -0x14(%ebp),%eax
    512b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    512e:	89 50 04             	mov    %edx,0x4(%eax)
    5131:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5134:	a3 a8 6b 00 00       	mov    %eax,0x6ba8
    5139:	8b 45 ec             	mov    -0x14(%ebp),%eax
    513c:	83 c0 08             	add    $0x8,%eax
    513f:	eb 38                	jmp    5179 <malloc+0xde>
    5141:	a1 a8 6b 00 00       	mov    0x6ba8,%eax
    5146:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    5149:	75 1b                	jne    5166 <malloc+0xcb>
    514b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    514e:	89 04 24             	mov    %eax,(%esp)
    5151:	e8 ed fe ff ff       	call   5043 <morecore>
    5156:	89 45 ec             	mov    %eax,-0x14(%ebp)
    5159:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    515d:	75 07                	jne    5166 <malloc+0xcb>
    515f:	b8 00 00 00 00       	mov    $0x0,%eax
    5164:	eb 13                	jmp    5179 <malloc+0xde>
    5166:	8b 45 ec             	mov    -0x14(%ebp),%eax
    5169:	89 45 f0             	mov    %eax,-0x10(%ebp)
    516c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    516f:	8b 00                	mov    (%eax),%eax
    5171:	89 45 ec             	mov    %eax,-0x14(%ebp)
    5174:	e9 70 ff ff ff       	jmp    50e9 <malloc+0x4e>
    5179:	c9                   	leave  
    517a:	c3                   	ret    
    517b:	90                   	nop

0000517c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    517c:	55                   	push   %ebp
    517d:	89 e5                	mov    %esp,%ebp
    517f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    5182:	8b 55 08             	mov    0x8(%ebp),%edx
    5185:	8b 45 0c             	mov    0xc(%ebp),%eax
    5188:	8b 4d 08             	mov    0x8(%ebp),%ecx
    518b:	f0 87 02             	lock xchg %eax,(%edx)
    518e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    5191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    5194:	c9                   	leave  
    5195:	c3                   	ret    

00005196 <lock_init>:
#include "x86.h"
#include "proc.h"

unsigned long rands = 1;

void lock_init(lock_t *lock){
    5196:	55                   	push   %ebp
    5197:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
    5199:	8b 45 08             	mov    0x8(%ebp),%eax
    519c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    51a2:	5d                   	pop    %ebp
    51a3:	c3                   	ret    

000051a4 <lock_acquire>:
void lock_acquire(lock_t *lock){
    51a4:	55                   	push   %ebp
    51a5:	89 e5                	mov    %esp,%ebp
    51a7:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
    51aa:	8b 45 08             	mov    0x8(%ebp),%eax
    51ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    51b4:	00 
    51b5:	89 04 24             	mov    %eax,(%esp)
    51b8:	e8 bf ff ff ff       	call   517c <xchg>
    51bd:	85 c0                	test   %eax,%eax
    51bf:	75 e9                	jne    51aa <lock_acquire+0x6>
}
    51c1:	c9                   	leave  
    51c2:	c3                   	ret    

000051c3 <lock_release>:
void lock_release(lock_t *lock){
    51c3:	55                   	push   %ebp
    51c4:	89 e5                	mov    %esp,%ebp
    51c6:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
    51c9:	8b 45 08             	mov    0x8(%ebp),%eax
    51cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    51d3:	00 
    51d4:	89 04 24             	mov    %eax,(%esp)
    51d7:	e8 a0 ff ff ff       	call   517c <xchg>
}
    51dc:	c9                   	leave  
    51dd:	c3                   	ret    

000051de <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
    51de:	55                   	push   %ebp
    51df:	89 e5                	mov    %esp,%ebp
    51e1:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
    51e4:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
    51eb:	e8 ab fe ff ff       	call   509b <malloc>
    51f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
    51f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    51f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
    51f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    51fc:	25 ff 0f 00 00       	and    $0xfff,%eax
    5201:	85 c0                	test   %eax,%eax
    5203:	74 15                	je     521a <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
    5205:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5208:	89 c2                	mov    %eax,%edx
    520a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    5210:	b8 00 10 00 00       	mov    $0x1000,%eax
    5215:	29 d0                	sub    %edx,%eax
    5217:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
    521a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    521e:	75 1b                	jne    523b <thread_create+0x5d>

        printf(1,"malloc fail \n");
    5220:	c7 44 24 04 b9 6a 00 	movl   $0x6ab9,0x4(%esp)
    5227:	00 
    5228:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    522f:	e8 81 fb ff ff       	call   4db5 <printf>
        return 0;
    5234:	b8 00 00 00 00       	mov    $0x0,%eax
    5239:	eb 6f                	jmp    52aa <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
    523b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    523e:	8b 55 08             	mov    0x8(%ebp),%edx
    5241:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5244:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    5248:	89 54 24 08          	mov    %edx,0x8(%esp)
    524c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    5253:	00 
    5254:	89 04 24             	mov    %eax,(%esp)
    5257:	e8 60 fa ff ff       	call   4cbc <clone>
    525c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
    525f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    5263:	79 1b                	jns    5280 <thread_create+0xa2>
        printf(1,"clone fails\n");
    5265:	c7 44 24 04 c7 6a 00 	movl   $0x6ac7,0x4(%esp)
    526c:	00 
    526d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    5274:	e8 3c fb ff ff       	call   4db5 <printf>
        return 0;
    5279:	b8 00 00 00 00       	mov    $0x0,%eax
    527e:	eb 2a                	jmp    52aa <thread_create+0xcc>
    }
    if(tid > 0){
    5280:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    5284:	7e 05                	jle    528b <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
    5286:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5289:	eb 1f                	jmp    52aa <thread_create+0xcc>
    }
    if(tid == 0){
    528b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    528f:	75 14                	jne    52a5 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
    5291:	c7 44 24 04 d4 6a 00 	movl   $0x6ad4,0x4(%esp)
    5298:	00 
    5299:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    52a0:	e8 10 fb ff ff       	call   4db5 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
    52a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    52aa:	c9                   	leave  
    52ab:	c3                   	ret    

000052ac <random>:

// generate 0 -> max random number exclude max.
int random(int max){
    52ac:	55                   	push   %ebp
    52ad:	89 e5                	mov    %esp,%ebp
    rands = rands * 1664525 + 1013904233;
    52af:	a1 18 6b 00 00       	mov    0x6b18,%eax
    52b4:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    52ba:	05 69 f3 6e 3c       	add    $0x3c6ef369,%eax
    52bf:	a3 18 6b 00 00       	mov    %eax,0x6b18
    return (int)(rands % max);
    52c4:	a1 18 6b 00 00       	mov    0x6b18,%eax
    52c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    52cc:	ba 00 00 00 00       	mov    $0x0,%edx
    52d1:	f7 f1                	div    %ecx
    52d3:	89 d0                	mov    %edx,%eax
}
    52d5:	5d                   	pop    %ebp
    52d6:	c3                   	ret    
    52d7:	90                   	nop

000052d8 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
    52d8:	55                   	push   %ebp
    52d9:	89 e5                	mov    %esp,%ebp
    q->size = 0;
    52db:	8b 45 08             	mov    0x8(%ebp),%eax
    52de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
    52e4:	8b 45 08             	mov    0x8(%ebp),%eax
    52e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
    52ee:	8b 45 08             	mov    0x8(%ebp),%eax
    52f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
    52f8:	5d                   	pop    %ebp
    52f9:	c3                   	ret    

000052fa <add_q>:

void add_q(struct queue *q, int v){
    52fa:	55                   	push   %ebp
    52fb:	89 e5                	mov    %esp,%ebp
    52fd:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
    5300:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    5307:	e8 8f fd ff ff       	call   509b <malloc>
    530c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
    530f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5312:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
    5319:	8b 45 f4             	mov    -0xc(%ebp),%eax
    531c:	8b 55 0c             	mov    0xc(%ebp),%edx
    531f:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
    5321:	8b 45 08             	mov    0x8(%ebp),%eax
    5324:	8b 40 04             	mov    0x4(%eax),%eax
    5327:	85 c0                	test   %eax,%eax
    5329:	75 0b                	jne    5336 <add_q+0x3c>
        q->head = n;
    532b:	8b 45 08             	mov    0x8(%ebp),%eax
    532e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    5331:	89 50 04             	mov    %edx,0x4(%eax)
    5334:	eb 0c                	jmp    5342 <add_q+0x48>
    }else{
        q->tail->next = n;
    5336:	8b 45 08             	mov    0x8(%ebp),%eax
    5339:	8b 40 08             	mov    0x8(%eax),%eax
    533c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    533f:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
    5342:	8b 45 08             	mov    0x8(%ebp),%eax
    5345:	8b 55 f4             	mov    -0xc(%ebp),%edx
    5348:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
    534b:	8b 45 08             	mov    0x8(%ebp),%eax
    534e:	8b 00                	mov    (%eax),%eax
    5350:	8d 50 01             	lea    0x1(%eax),%edx
    5353:	8b 45 08             	mov    0x8(%ebp),%eax
    5356:	89 10                	mov    %edx,(%eax)
}
    5358:	c9                   	leave  
    5359:	c3                   	ret    

0000535a <empty_q>:

int empty_q(struct queue *q){
    535a:	55                   	push   %ebp
    535b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
    535d:	8b 45 08             	mov    0x8(%ebp),%eax
    5360:	8b 00                	mov    (%eax),%eax
    5362:	85 c0                	test   %eax,%eax
    5364:	75 07                	jne    536d <empty_q+0x13>
        return 1;
    5366:	b8 01 00 00 00       	mov    $0x1,%eax
    536b:	eb 05                	jmp    5372 <empty_q+0x18>
    else
        return 0;
    536d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
    5372:	5d                   	pop    %ebp
    5373:	c3                   	ret    

00005374 <pop_q>:
int pop_q(struct queue *q){
    5374:	55                   	push   %ebp
    5375:	89 e5                	mov    %esp,%ebp
    5377:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
    537a:	8b 45 08             	mov    0x8(%ebp),%eax
    537d:	89 04 24             	mov    %eax,(%esp)
    5380:	e8 d5 ff ff ff       	call   535a <empty_q>
    5385:	85 c0                	test   %eax,%eax
    5387:	75 5d                	jne    53e6 <pop_q+0x72>
       val = q->head->value; 
    5389:	8b 45 08             	mov    0x8(%ebp),%eax
    538c:	8b 40 04             	mov    0x4(%eax),%eax
    538f:	8b 00                	mov    (%eax),%eax
    5391:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
    5394:	8b 45 08             	mov    0x8(%ebp),%eax
    5397:	8b 40 04             	mov    0x4(%eax),%eax
    539a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
    539d:	8b 45 08             	mov    0x8(%ebp),%eax
    53a0:	8b 40 04             	mov    0x4(%eax),%eax
    53a3:	8b 50 04             	mov    0x4(%eax),%edx
    53a6:	8b 45 08             	mov    0x8(%ebp),%eax
    53a9:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
    53ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    53af:	89 04 24             	mov    %eax,(%esp)
    53b2:	e8 b5 fb ff ff       	call   4f6c <free>
       q->size--;
    53b7:	8b 45 08             	mov    0x8(%ebp),%eax
    53ba:	8b 00                	mov    (%eax),%eax
    53bc:	8d 50 ff             	lea    -0x1(%eax),%edx
    53bf:	8b 45 08             	mov    0x8(%ebp),%eax
    53c2:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
    53c4:	8b 45 08             	mov    0x8(%ebp),%eax
    53c7:	8b 00                	mov    (%eax),%eax
    53c9:	85 c0                	test   %eax,%eax
    53cb:	75 14                	jne    53e1 <pop_q+0x6d>
            q->head = 0;
    53cd:	8b 45 08             	mov    0x8(%ebp),%eax
    53d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
    53d7:	8b 45 08             	mov    0x8(%ebp),%eax
    53da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
    53e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    53e4:	eb 05                	jmp    53eb <pop_q+0x77>
    }
    return -1;
    53e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    53eb:	c9                   	leave  
    53ec:	c3                   	ret    