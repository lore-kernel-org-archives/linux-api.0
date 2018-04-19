From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked down
Date: Thu, 19 Apr 2018 15:38:53 +0100
Message-ID: <27926.1524148733@warthog.procyon.org.uk>
References: <20180413202234.GA4484@amd> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413202234.GA4484@amd>
Content-ID: <27925.1524148733.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> > There is currently no way to verify the resume image when returning
> > from hibernate.  This might compromise the signed modules trust model,
> > so until we can work with signed hibernate images we disable it when the
> > kernel is locked down.
> 
> I'd rather see hibernation fixed than disabled like this.

The problem is that you have to store the hibernated kernel image encrypted,
but you can't store the decryption key on disk unencrypted or you've just
wasted the effort.

So the firmware has to unlock the image, asking the user for a password to
unlock the key.

David
