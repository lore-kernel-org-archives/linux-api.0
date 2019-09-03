From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 11/11] smack: Implement the watch_key and post_notification hooks [untested] [ver #7]
Date: Tue, 03 Sep 2019 19:06:54 +0100
Message-ID: <11467.1567534014@warthog.procyon.org.uk>
References: <87bf0363-af77-1e5a-961f-72730e39e3a6@schaufler-ca.com> <e36fa722-a300-2abf-ae9c-a0246fc66d0e@schaufler-ca.com> <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk> <156717352917.2204.17206219813087348132.stgit@warthog.procyon.org.uk> <4910.1567525310@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87bf0363-af77-1e5a-961f-72730e39e3a6@schaufler-ca.com>
Content-ID: <11466.1567534014.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> Built from your tree.

What branch?  keys-next?

> keyctl move 483362336 1065401533 @s
> keyctl_move: Operation not supported

Odd.  That should be unconditional if you have CONFIG_KEYS and v5.3-rc1.  Can
you try:

	keyctl supports

or just:

	keyctl add user a a @s

which will give you an id, say 1234, then:

	keyctl move 1234 @s @u

see if that works.

David
