From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/24] kexec_load: Disable at runtime if the kernel is locked down
Date: Wed, 11 Apr 2018 21:05:56 +0100
Message-ID: <12601.1523477156@warthog.procyon.org.uk>
References: <87po35k1q6.fsf@xmission.com> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346391877.4030.6270466586590461223.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87po35k1q6.fsf@xmission.com>
Content-ID: <12600.1523477156.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> Maybing I am missing it but I am not seeing anything that would require
> kexec_file_load be configured such that it checks the loaded kernel.
> 
> Without that I don't see the point of disabling kexec_load.

I meant to remove this patch too.

David
