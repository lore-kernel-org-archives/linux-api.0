From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 00:22:08 +0200
Message-ID: <878t2wb4dr.fsf@mid.deneb.enyo.de>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
        <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca>
        <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
        <E9903911-9289-4038-9835-9353762A3BAF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E9903911-9289-4038-9835-9353762A3BAF@dilger.ca> (Andreas
        Dilger's message of "Wed, 17 Oct 2018 14:22:57 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Michael Kerrisk <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Andreas Dilger:

>> So what's the point exactly?
>
> Ah, I see your point...  STATX_ALL seems to be mostly useful for the kernel
> to mask off flags that it doesn't currently understand.  It doesn't make
> much sense for applications to specify STATX_ALL, since they don't have any
> way to know what each flag means unless they are hard-coded to check each of
> the STATX_* flags individually.  They should build up a mask of STATX_* flags
> based on what they care about (e.g. "find" should only request attributes
> based on the command-line options given).

Could you remove it from the UAPI header?  I didn't want to put it
into the glibc header, but was overruled.
