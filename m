From: Maninder Singh <maninder1.s@samsung.com>
Subject: RE: [PATCH 1/1] selftest/net: fix FILE_SIZE for 32 bit
 architecture.
Date: Fri, 10 Aug 2018 11:33:41 +0530
Message-ID: <20180810060341epcms5p4e8defed12cf0adeccd4d8d1e3c93c6b3@epcms5p4>
References: <4f2c8d694dce4125a609e8d5383ebe36@AcuMS.aculab.com>
        <4a412194-99aa-7969-54a4-727368fbf82c@gmail.com>
        <20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0~HCuTv0d7l2131721317epcas5p4u@epcas5p4.samsung.com>
        <20180803033159epcms5p1dd2f5a6834268e9a22efa15421795fa0@epcms5p1>
        <CGME20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0@epcms5p4>
Reply-To: maninder1.s@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4f2c8d694dce4125a609e8d5383ebe36@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, Eric Dumazet <eric.dumazet@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>
Cc: "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "edumazet@google.com" <edumazet@google.com>, PANKAJ MISHRA <pankaj.m@samsung.com>, AMIT SAHRAWAT <a.sahrawat@samsung.com>, Vaneet Narang <v.narang@samsung.com>
List-Id: linux-api@vger.kernel.org

>> >
>> >What about using more conventional size_t instead of "unsigned long long" ?
>> 
>> size_t is also equivalent to unsigned long and it will not hold value of (1 << 35) for 32 bit system.
>> So we can do two things.
> 
>Wouldn't the 'correct' type be off_t ?
>In any case, IIRC, you have to do really horrid things in Linux to
>access files larger than 2G on 32bit systems.
> 
>        David

Any inputs.

Thanks,
Maninder Singh
