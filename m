From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked
 down
Date: Thu, 26 Apr 2018 10:20:29 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1804261018030.28147@cbobk.fhfr.pm>
References: <20180413202234.GA4484@amd> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk> <27926.1524148733@warthog.procyon.org.uk> <20180426072646.GA31822@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426072646.GA31822@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, Joey Lee <JLee@suse.com>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 26 Apr 2018, Pavel Machek wrote:

> That's not how the crypto needs to work. Talk to Jiri Kosina, ok?

Yeah, Joey Lee (adding to CC) implemented it here:

	https://lkml.org/lkml/2015/8/11/47

I think there have been more respins, Joey definitely knows more details 
and status quo.

The design is specifically tailored for secure-boot environments though.

-- 
Jiri Kosina
SUSE Labs
