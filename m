From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 11/11] smack: Implement the watch_key and post_notification hooks [untested] [ver #7]
Date: Tue, 03 Sep 2019 16:41:50 +0100
Message-ID: <4910.1567525310@warthog.procyon.org.uk>
References: <e36fa722-a300-2abf-ae9c-a0246fc66d0e@schaufler-ca.com> <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk> <156717352917.2204.17206219813087348132.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e36fa722-a300-2abf-ae9c-a0246fc66d0e@schaufler-ca.com>
Content-ID: <4909.1567525310.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> I tried running your key tests and they fail in "keyctl/move/valid",
> with 11 FAILED messages, finally hanging after "UNLINK KEY FROM SESSION".
> It's possible that my Fedora26 system is somehow incompatible with the
> tests. I don't see anything in your code that would cause this, as the
> Smack policy on the system shouldn't restrict any access.

Can you go into keyutils/tests/keyctl/move/valid/ and grab the test.out file?

I presume you're running with an upstream-ish kernel and a cutting edge
keyutils installed?

David
