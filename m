From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v7 1/1] ns: add binfmt_misc to the user namespace
Date: Mon, 16 Dec 2019 10:13:24 +0100
Message-ID: <dbd19cb9-9172-d89d-f796-05a23213ca69@vivier.eu>
References: <20191107140304.8426-1-laurent@vivier.eu>
 <20191107140304.8426-2-laurent@vivier.eu>
 <7cb245ed-f738-7991-a09b-b27152274b9f@vivier.eu>
 <20191213185110.06b52cf4@md1za8fc.ad001.siemens.net>
 <1576267177.4060.4.camel@HansenPartnership.com>
 <3205e74b-71f1-14f4-b784-d878b3ef697f@vivier.eu>
 <CAKgNAkiaKJZMA0pzvwDa75CxfULTL1LmOZDzhW0Y5TmL7nBGZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkiaKJZMA0pzvwDa75CxfULTL1LmOZDzhW0Y5TmL7nBGZw@mail.gmail.com>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Henning Schild <henning.schild@siemens.com>, lkml <linux-kernel@vger.kernel.org>, Dmitry Safonov <dima@arista.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Eric Biederman <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, Andrei Vagin <avagin@gmail.com>, =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>, Greg Kurz <groug@kaod.org>, Jann Horn <jannh@google.com>, Containers <containers@lists.linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kiszka <jan.kiszka@siemens.com>
List-Id: linux-api@vger.kernel.org

Le 14/12/2019 à 13:32, Michael Kerrisk (man-pages) a écrit :
> Hello Laurent,
> 
> On Sat, 14 Dec 2019 at 12:35, Laurent Vivier <laurent@vivier.eu> wrote:
>>
>> Le 13/12/2019 à 20:59, James Bottomley a écrit :
>>> On Fri, 2019-12-13 at 18:51 +0100, Henning Schild wrote:
>>>> Hi all,
>>>>
>>>> that is a very useful contribution, which will hopefully be
>>>> considered.
>>>
>>> I'm technically the maintainer on the you touched it last you own it
>>> basis, so if Christian's concerns get addressed I'll shepherd it
>>> upstream.
>>
>> Thank you.
>>
>> I update this in the next days and re-send the patch.
> 
> Would you also be so kind as to craft a patch for the
> user_namespaces(7) manual page describing the changes (sent to me,
> linux-man@vger.kernel.org, and the other parties already in CC)?
> 
> If you do not have the time to familiarize yourself with groff/man
> markup, a patch that uses plain text is fine; I can handle the
> formatting.

I will send a patch for the user_namespaces(7) manual.

Thanks,
Laurent
