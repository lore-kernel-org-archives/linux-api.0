From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Wed, 2 May 2018 11:12:27 +0200
Message-ID: <20180502111227.346f355e@redhat.com>
References: <20180306013457.1955486-1-ast@kernel.org>
        <CA+55aFx5Q8D3cmuoXJFV9Ok_vc3fd3rNP-5onqFTPTtfZgi=HQ@mail.gmail.com>
        <EED9C7CB-BC5D-4E2D-B0CC-0003F682C73B@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EED9C7CB-BC5D-4E2D-B0CC-0003F682C73B@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <clm@fb.com>
Cc: brouer@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, David Miller <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


On Tue, 6 Mar 2018 15:42:41 -0800 Chris Mason <clm@fb.com> wrote:
> On 6 Mar 2018, at 11:12, Linus Torvalds wrote:
> 
[...]
> >
> > I do *not* want this to be a magical way to hide things.  
> 
> Especially early on, this makes a lot of sense.  But I wanted to plug 
> bps and the hopefully growing set of bpf introspection tools:
> 
> https://github.com/iovisor/bcc/blob/master/introspection/bps_example.txt
> 
> Long term these are probably a good place to tell the admin what's going 
> on.
(related to bpf itself not modprobe subject)

Hi Chris,

I just want to point out that the tool 'bpftool', is currently the
dominating tool for eBPF introspection.  And the 'bps' tool you mention
seems to have gained less (open source) traction.

The bpftool is part of the kernel git-tree: tools/bpf/bpftool
 https://github.com/torvalds/linux/blob/master/tools/bpf/bpftool/

And it even have bash-completion and man-pages in RST format so they
even render nicely when viewed via github:

 https://github.com/torvalds/linux/blob/master/tools/bpf/bpftool/Documentation/bpftool.rst
 https://github.com/torvalds/linux/blob/master/tools/bpf/bpftool/Documentation/bpftool-prog.rst
 https://github.com/torvalds/linux/blob/master/tools/bpf/bpftool/Documentation/bpftool-map.rst

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
