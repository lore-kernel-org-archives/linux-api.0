From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V35 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Tue, 16 Jul 2019 13:32:33 -0700
Message-ID: <CACdnJuudpnaQ5YUhoxmxNWVdRB6v0u0Bf2O6NmYOXjp8_govyg@mail.gmail.com>
References: <20190715195946.223443-1-matthewgarrett@google.com>
 <20190715195946.223443-24-matthewgarrett@google.com> <5d363f09-d649-5693-45c0-bb99d69f0f38@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5d363f09-d649-5693-45c0-bb99d69f0f38@iogearbox.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 15, 2019 at 3:54 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> Hmm, does security_locked_down() ever return a code > 0 or why do you
> have the double check on return code? If not, then for clarity the
> ret code from security_locked_down() should be checked as 'ret < 0'
> as well and out label should be at the memset directly instead.

It doesn't, so I'll update. Thanks!
