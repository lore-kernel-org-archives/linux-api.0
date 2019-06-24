From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V34 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
Date: Mon, 24 Jun 2019 13:15:44 -0700
Message-ID: <CACdnJuu20Rsb-9XAcTR5Q9RJ5wY7ATazS7dLgDODH+YSZU50Tg@mail.gmail.com>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-24-matthewgarrett@google.com> <739e21b5-9559-d588-3542-bf0bc81de1b2@iogearbox.net>
 <CACdnJuvR2bn3y3fYzg06GWXXgAGjgED2Dfa5g0oAwJ28qCCqBg@mail.gmail.com> <CALCETrWmZX3R1L88Gz9vLY68gcK8zSXL4cA4GqAzQoyqSR7rRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWmZX3R1L88Gz9vLY68gcK8zSXL4cA4GqAzQoyqSR7rRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Jann Horn <jannh@google.com>, bpf@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 1:09 PM Andy Lutomirski <luto@kernel.org> wrote:

> I'm confused.  I understand why we're restricting bpf_probe_read().
> Why are we restricting bpf_probe_write_user() and bpf_trace_printk(),
> though?

Hmm. I think the thinking here was around exfiltration mechanisms, but
if the read is blocked then that seems less likely. This seems to
trace back to http://kernsec.org/pipermail/linux-security-module-archive/2017-October/003545.html
- Joey, do you know the reasoning here?
