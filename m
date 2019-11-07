From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 04/14] pipe: Add O_NOTIFICATION_PIPE [ver #2]
Date: Thu, 7 Nov 2019 10:16:13 -0800
Message-ID: <CALCETrUka9KaOKFbNKUXcA6XvoFxiXPftctSHtN4DL35Cay61w@mail.gmail.com>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
 <157313375678.29677.15875689548927466028.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157313375678.29677.15875689548927466028.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 7, 2019 at 5:39 AM David Howells <dhowells@redhat.com> wrote:
>
> Add an O_NOTIFICATION_PIPE flag that can be passed to pipe2() to indicate
> that the pipe being created is going to be used for notifications.  This
> suppresses the use of splice(), vmsplice(), tee() and sendfile() on the
> pipe as calling iov_iter_revert() on a pipe when a kernel notification
> message has been inserted into the middle of a multi-buffer splice will be
> messy.

How messy?  And is there some way to make it impossible for this to
happen?  Adding a new flag to pipe2() to avoid messy kernel code seems
like a poor tradeoff.
