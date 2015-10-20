From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v6 0/4] of: overlay: kobject & sysfs'ation
Date: Tue, 20 Oct 2015 16:52:13 -0500
Message-ID: <CAL_JsqKXdW3V10axsLTChtvkHtCjc+gVoPqzk0igqJ-+fKrY=A@mail.gmail.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com>
 <CAL_JsqKzwUeZp=pBcxh=4kBhY-6EQDozBweiACUYW1L=1gC4SQ@mail.gmail.com> <BFDE85A8-5F13-4CB7-A027-2E7BEB8A8F1C@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BFDE85A8-5F13-4CB7-A027-2E7BEB8A8F1C@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 4:11 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Hi Rob,
>
>> On Oct 21, 2015, at 00:06 , Rob Herring <robherring2@gmail.com> wrot=
e:
>>
>> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
>> <pantelis.antoniou@konsulko.com> wrote:
>>> The first patch puts the overlays as objects in the sysfs in
>>> /sys/firmware/devicetree/overlays.
>>>
>>> The next adds a master overlay enable switch (that once is set to
>>> disabled can't be re-enabled), while the one after that
>>> introduces a number of default per overlay attributes.
>>>
>>> The patchset is against linus's tree as of today.
>>>
>>> The last patch updates the ABI docs for the sysfs entries.
>>
>> I think I told you I would take patches 1 and 2 if you split out the
>> sysfs documentation for that part of it.
>>
>
> Sorry, but I haven=E2=80=99t seen them being picked up anywhere, so I=
 resent them to be on the safe side.

You would need to separate the kill switch sysfs documentation in
patch 4 for me to take just the global part. Or just continue to send
them all. :)

Rob
