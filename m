From: =?ISO-8859-1?Q?Stephan_M=FCller?= <fruktopus@gmail.com>
Subject: Re: [PATCH] Change userspace MKDEV, MAJOR, MINOR-macros from 8+8
 bit, to 12+20 bit layout
Date: Sun, 14 Sep 2014 20:22:30 +0200
Message-ID: <5415DCE6.301@gmail.com>
References: <5415D1E0.3020905@gmail.com> <20140914174622.GA10315@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140914174622.GA10315@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am 14.09.2014 19:46, schrieb Greg KH:
> On Sun, Sep 14, 2014 at 07:35:28PM +0200, Stephan M=FCller wrote:
>> Delete old userspace-only versions (8+8 bit). Instead expose the ker=
nel-space
>> definitions (12+20 bit).
>>
>> Signed-off-by: Stephan Mueller <fruktopus@gmail.com>
>> ---
>>
>> Browsing some code I found that user-space and kernel-space macros f=
or (un-)packing major/minor device numbers differ. The user-space ones =
using still the old 16 bit scheme. There was no explaining comment arou=
nd and most libraries have their own macros anyway so it should not be =
a problematic UAPI change. So IMHO we could win some coherence in aband=
on this discrepancy.
>> Please correct me if I am wrong.
>=20
> You are wrong, we can't change this api, things will break :(
>=20
> sorry,
>=20
> greg k-h

I kind of expected this. The #ifndef __KERNEL__ was suspicious..

 thanks
