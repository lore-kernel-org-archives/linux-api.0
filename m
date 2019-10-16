From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 02/21] Add a prelocked wake-up
Date: Wed, 16 Oct 2019 08:31:48 -0700
Message-ID: <CAHk-=wgMZR8TWpmRBPytGmWJX=C=-bCb5D2PsCx0LUNemAPexA@mail.gmail.com>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
 <157117608708.15019.1998141309054662114.stgit@warthog.procyon.org.uk>
 <CAHk-=whiz1sHXu8SVZKEC2dup=r5JMrftPtEt6ff9Ea8dyH8yQ@mail.gmail.com> <6900.1571235985@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6900.1571235985@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Kan Liang <kan.liang@intel.com>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 16, 2019 at 7:26 AM David Howells <dhowells@redhat.com> wrote:
>
> Btw, is there any point in __wake_up_sync_key() taking a nr_exclusive
> argument since it clears WF_SYNC if nr_exclusive != 1 and doesn't make sense
> to be >1 anyway.

Ack, looks sane to me.

We have _very_ few users of nr_exclusive. I wonder if it's even worth
having at all, but it's definitely not worth it here.

I'd love for nr_exclusive to go away and be replaced by WF_ALL
instead. Right now it looks like there is one SGI driver that uses it,
and the sbitmap code. That was all I could find.

Oh well. You removing one case is at last a small amount of progress.

         Linus
