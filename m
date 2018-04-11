From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is locked down
Date: Wed, 11 Apr 2018 21:08:21 +0100
Message-ID: <12741.1523477301@warthog.procyon.org.uk>
References: <87zi29k26z.fsf@xmission.com> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zi29k26z.fsf@xmission.com>
Content-ID: <12740.1523477301.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> Why is mounting debugfs allowed at all?  Last I checked (it has been a while)
> the code quality of debugfs was fine for debugging but debugfs was not
> safe to mount on a production system.
> 
> Maybe the code quality is better now but for a filesystem that is
> not supposed to be needed for developers letting us mount debugfs
> seems odd.

I agree.  But debugfs has been abused and it seems that there are some things
that use it as an interface between a kernel driver and the userspace side.

David
