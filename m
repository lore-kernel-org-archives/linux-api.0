From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 23/27] bpf: Restrict kernel image access functions when
 the kernel is locked down
Date: Tue, 26 Mar 2019 13:19:10 -0700
Message-ID: <CACdnJuskoACijaifrNQhqRtr07uPN7LT8m=FNgcxgJRiwDLVkw@mail.gmail.com>
References: <20190325220954.29054-1-matthewgarrett@google.com>
 <20190325220954.29054-24-matthewgarrett@google.com> <20190325164221.5d8687bd@shemminger-XPS-13-9360>
 <CALCETrU=EqqRwyQGBT0=_N9-E_pBM53=z+WJrd9OzV7g6xJa0A@mail.gmail.com> <alpine.LRH.2.21.1903270523240.5235@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1903270523240.5235@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Andy Lutomirski <luto@kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 11:57 AM James Morris <jmorris@namei.org> wrote:
> - Assign an ID to each lockdown point
> - Implement a policy mechanism where each ID is mapped to 0 or 1
> - Allow this policy to be specified statically or dynamically

One of the problems with this approach is what the default behaviour
should be when a new feature is added. If an admin fails to notice
that there's now a new policy element, they run the risk of kernel
integrity being compromised via the new feature even if the rest of
the kernel is locked down.
