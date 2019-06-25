From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V31 07/25] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Mon, 24 Jun 2019 17:02:29 -0700
Message-ID: <CACdnJuvE-MbD42AJTrio=0RaN8SaWo-RHHt21z=3an1vtjTFhA@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-8-matthewgarrett@google.com> <20190621064340.GB4528@localhost.localdomain>
 <CACdnJut=J1YTpM4s6g5XWCEs+=X0Jvf8otfMg+w=_oqSZmf01Q@mail.gmail.com>
 <20190624015206.GB2976@dhcp-128-65.nay.redhat.com> <CACdnJusPtYLdg7ZPhBo=Y5EsBz6B+5M2zYscBrLcc89oNnPkdQ@mail.gmail.com>
 <1561411657.4340.70.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1561411657.4340.70.camel@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Dave Young <dyoung@redhat.com>, James Morris <jmorris@namei.org>, Jiri Bohac <jbohac@suse.cz>, Linux API <linux-api@vger.kernel.org>, kexec@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 2:27 PM Mimi Zohar <zohar@linux.ibm.com> wrote:

> I agree with Dave.  There should be a stub lockdown function to
> prevent enforcing lockdown when it isn't enabled.

Sorry, when what isn't enabled? If no LSMs are enforcing lockdown then
the check will return 0. The goal here is for distributions to be able
to ship a kernel that has CONFIG_KEXEC_SIG=y, CONFIG_KEXEC_SIG_FORCE=n
and at runtime be able to enforce a policy that requires signatures on
kexec payloads.
