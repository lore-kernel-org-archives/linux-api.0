From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 09:37:44 +0200
Message-ID: <CAJfpegscdd7Q7waB4me7RMC_SJv4=rQwEGXBYNGAr2F3WE5=zA@mail.gmail.com>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
 <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca> <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
 <E9903911-9289-4038-9835-9353762A3BAF@dilger.ca> <878t2wb4dr.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t2wb4dr.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Andreas Dilger <adilger@dilger.ca>, Michael Kerrisk <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 18, 2018 at 12:22 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * Andreas Dilger:
>
>>> So what's the point exactly?
>>
>> Ah, I see your point...  STATX_ALL seems to be mostly useful for the kernel
>> to mask off flags that it doesn't currently understand.  It doesn't make
>> much sense for applications to specify STATX_ALL, since they don't have any
>> way to know what each flag means unless they are hard-coded to check each of
>> the STATX_* flags individually.  They should build up a mask of STATX_* flags
>> based on what they care about (e.g. "find" should only request attributes
>> based on the command-line options given).
>
> Could you remove it from the UAPI header?  I didn't want to put it
> into the glibc header, but was overruled.

To summarize Linus' rule of backward incompatibility: you can do it as
long as nobody notices.  So yeah, we could try removing STATX_ALL from
the uapi header, but we'd have to put it back in, once somebody
complains.

Thanks,
Miklos
