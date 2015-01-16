From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Fri, 16 Jan 2015 14:18:24 -0800
Message-ID: <20150116221824.GA512@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <CA+5PVA7idthaLM_VTLdLEU=z=mbYnEkdQOSGSXqdJHJTNAHkzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA7idthaLM_VTLdLEU=z=mbYnEkdQOSGSXqdJHJTNAHkzA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, daniel@zonque.org, David Herrmann <dh.herrmann@gmail.com>, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 05:07:25PM -0500, Josh Boyer wrote:
> On Fri, Jan 16, 2015 at 2:16 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This can also be found in a git tree, the kdbus branch of char-misc.git at:
> >         https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/
> 
> Is this now the canonical tree?  I ask because the github tree hasn't
> been updated in quite some time.

That's my fault, it's just a mirror of the code.google.com tree for
people who like to use github.  It's now updated.

> The code.google.com tree has commits
> from 2 days ago, but it still calls d_materialise_unique in fs.c
> whereas the patchset you've posted uses the correct d_splice_alias.
> So the code.google.com tree doesn't actually compile against 3.19-rcX.
> 
> I'm confused where we're supposed to track things now.

I think the google tree is the "correct" one, but when generating
patches, apis are tweaked to work properly with the latest -rc kernel
for submission.

Daniel knows more though, he's the one generating the patchsets, I don't
know how he's doing it exactly.

thanks,

greg k-h
