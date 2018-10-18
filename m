From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: statx(2) API and documentation
Date: Thu, 18 Oct 2018 09:49:28 +0200
Message-ID: <87in1zy9rr.fsf@mid.deneb.enyo.de>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
        <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca>
        <CAJfpeguvJZbP83mSULc74Yhpp_CPMBW1XvcgbvCbLnF7QCncUA@mail.gmail.com>
        <CAOQ4uxjqS3R_0O6gKVFEUJR7BvB+rpaHekjZm+fhMA+7on8AwQ@mail.gmail.com>
        <20181018074101.GJ23493@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018074101.GJ23493@quack2.suse.cz> (Jan Kara's message of
        "Thu, 18 Oct 2018 09:41:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Andreas Dilger <adilger@dilger.ca>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Jan Kara:

> On Thu 18-10-18 01:15:13, Amir Goldstein wrote:
>> FYI, I identified a similar anti-pattern in fanotify UAPI when I wanted to
>> add new flags and did not want to change the UAPI _ALL_ constants.
>> This is how we plan to solve it:
>> https://github.com/amir73il/linux/commit/8c2b1acadb88ee4505ccc8bfdc665863111fb4cc
>
> Yeah, after fanotify experience I find foo_ALL constants useless if not
> dangerous for userspace.  Kernel internal constants like this are IMO
> useful.

There are also various *_MAX constants which are increased regularly.
Some of them are part of the UAPI headers (INET_DIAG_MAX appears to be
a relevant example), some are no longer in UAPI, but still in custom
glibc headers (AF_MAX/PF_MAX).  These appear to be equally useless.
