From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Date: Wed, 23 Apr 2014 16:21:36 +0200
Message-ID: <CAJfpegsdUwxHOGxhiLtkMHzB==UGzbj+rAVOJGX4nb6z1Urzpw@mail.gmail.com>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-12-git-send-email-miklos@szeredi.hu>
	<20140113122517.GA10366@quack.suse.cz>
	<20140115182347.GB5715@fieldses.org>
	<CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
	<52D90B93.5010209@gmail.com>
	<20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <53523D16.9020101@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "mszeredi@suse.cz" <mszeredi@suse.cz>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sat, Apr 19, 2014 at 11:08 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi Miklos,
>
>> The code changes are pushed to the git tree and the updated man page is below.
>
> Now that renameat2() is in 3.15, I've taken these changes. This had to be
> manually does, because I'd done some major reworking on the pages since you
> originally wrote your text. So, I may have injected some errors.
>
> I did a little light reworking of the text and added VERSIONS and
> CONFORMING TO pieces. I also added a couple of FIXMEs, to note points
> that will need to be updated once glibc support is (presumably) added.
> (Carlos, what's the usual process for triggering that sort of thing?)
>
> Could you please review the diff below (now against rename(2)).

Looks okay.

One comment on the current rename.2 page:

  #include <fcntl.h>           /* Definition of AT_* constants */

AT_ constants are not used in renameat() hence this seems unneeded.

Not sure where the RENAME_ constants need to go once renameat2() is
added to glibc, possibly to <stdio.h> since they are closely related
to rename.

Thanks,
Miklos
