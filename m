From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Wed, 15 Jan 2020 14:25:17 +0000
Message-ID: <20200115142517.GI8904@ZenIV.linux.org.uk>
References: <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
 <20200114045733.GW8904@ZenIV.linux.org.uk>
 <20200114200150.ryld4npoblns2ybe@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200114200150.ryld4npoblns2ybe@yavin>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ian Kent <raven@themaw.net>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 15, 2020 at 07:01:50AM +1100, Aleksa Sarai wrote:

> Yes, there were two patches I sent a while ago[1]. I can re-send them if
> you like. The second patch switches open_how->mode to a u64, but I'm
> still on the fence about whether that makes sense to do...

IMO plain __u64 is better than games with __aligned_u64 - all sizes are
fixed, so...

> [1]: https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar@cyphar.com/

Do you want that series folded into "open: introduce openat2(2) syscall"
and "selftests: add openat2(2) selftests" or would you rather have them
appended at the end of the series.  Personally I'd go for "fold them in"
if it had been about my code, but it's really up to you.
