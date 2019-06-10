From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/13] keys: Add a notification facility [ver #4]
Date: Mon, 10 Jun 2019 18:47:11 +0100
Message-ID: <10632.1560188831@warthog.procyon.org.uk>
References: <20190610111110.72468326@lwn.net> <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk> <155991709983.15579.13232123365803197237.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610111110.72468326@lwn.net>
Content-ID: <10631.1560188831.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> wrote:

> > 	keyctl_watch_key(KEY_SPEC_SESSION_KEYRING, fd, 0x01);
> 
> One little nit: it seems that keyctl_watch_key is actually spelled
> keyctl(KEYCTL_WATCH_KEY, ...).

Yeah - but there'll be a wrapper for it in -lkeyutils.  The syscalls I added
in other patches are, technically, referred to syscall(__NR_xxx, ...) at the
moment too.

David
