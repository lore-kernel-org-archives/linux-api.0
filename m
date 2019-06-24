From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V31 07/25] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Mon, 24 Jun 2019 14:06:00 -0700
Message-ID: <CACdnJusPtYLdg7ZPhBo=Y5EsBz6B+5M2zYscBrLcc89oNnPkdQ@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-8-matthewgarrett@google.com> <20190621064340.GB4528@localhost.localdomain>
 <CACdnJut=J1YTpM4s6g5XWCEs+=X0Jvf8otfMg+w=_oqSZmf01Q@mail.gmail.com> <20190624015206.GB2976@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624015206.GB2976@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: James Morris <jmorris@namei.org>, Jiri Bohac <jbohac@suse.cz>, Linux API <linux-api@vger.kernel.org>, kexec@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 23, 2019 at 6:52 PM Dave Young <dyoung@redhat.com> wrote:
>
> On 06/21/19 at 01:18pm, Matthew Garrett wrote:
> > I don't think so - we want it to be possible to load images if they
> > have a valid signature.
>
> I know it works like this way because of the previous patch.  But from
> the patch log "When KEXEC_SIG is not enabled, kernel should not load
> images", it is simple to check it early for !IS_ENABLED(CONFIG_KEXEC_SIG) &&
> kernel_is_locked_down(reason, LOCKDOWN_INTEGRITY)  instead of depending
> on the late code to verify signature.  In that way, easier to
> understand the logic, no?

But that combination doesn't enforce signature validation? We can't
depend on !IS_ENABLED(CONFIG_KEXEC_SIG_FORCE) because then it'll
enforce signature validation even if lockdown is disabled.
