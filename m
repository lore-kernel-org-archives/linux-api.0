From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/11] Keyrings, Block and USB notifications [ver #7]
Date: Mon, 02 Sep 2019 13:39:33 +0100
Message-ID: <20964.1567427973@warthog.procyon.org.uk>
References: <563ae8b4-753a-179d-4f6d-94d2dd058f3b@schaufler-ca.com> <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <563ae8b4-753a-179d-4f6d-94d2dd058f3b@schaufler-ca.com>
Content-ID: <20963.1567427973.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > Tests for the key/keyring events can be found on the keyutils next branch:
> >
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/log/?h=next
> 
> I'm having trouble with the "make install" on Fedora. Is there an
> unusual dependency?

What's the symptom you're seeing?  Is it this:

install -D -m 0644 libkeyutils.a /tmp/opt/lib64 libcrypt.so.2 => /lib64/libcrypt.so.2 (0x00007f7dcbf6d000)/libkeyutils.a
/bin/sh: -c: line 0: syntax error near unexpected token `('
/bin/sh: -c: line 0: `install -D -m 0644 libkeyutils.a /tmp/opt/lib64 libcrypt.so.2 => /lib64/libcrypt.so.2 (0x00007f7dcbf6d000)/libkeyutils.a'

David
