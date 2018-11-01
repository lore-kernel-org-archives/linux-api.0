From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 0/1] ns: introduce binfmt_misc namespace
Date: Wed, 31 Oct 2018 19:59:19 -0700
Message-ID: <1541041159.4632.6.camel@HansenPartnership.com>
References: <20181010161430.11633-1-laurent@vivier.eu>
         <7ed6f823-547b-922d-59ff-aba9c4c3ab39@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7ed6f823-547b-922d-59ff-aba9c4c3ab39@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>, linux-kernel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Dmitry Safonov <dima@arista.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2018-10-16 at 11:52 +0200, Laurent Vivier wrote:
> Hi,
> 
> Any comment on this last version?
> 
> Any chance to be merged?

I've got a use case for this:  I went to one of the Graphene talks in
Edinburgh and it struck me that we seem to keep reinventing the type of
sandboxing that qemu-user already does.  However if you want to do an
x86 on x86 sandbox, you can't currently use the binfmt_misc mechanism
because that has you running *every* binary on the system emulated. 
Doing it per user namespace fixes this problem and allows us to at
least cut down on all the pointless duplication.

James
