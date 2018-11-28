From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v3 3/4] libbpf: add bpf_prog_test_run_xattr
Date: Tue, 27 Nov 2018 21:05:13 -0800
Message-ID: <CAADnVQ+CJsUUG2otaLJjvnNQ55tRx6ANsFUrTWkb-k=Ztw1MRg@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com> <20181122140910.1079-1-lmb@cloudflare.com>
 <20181122140910.1079-4-lmb@cloudflare.com> <b4308b6f-5a1d-f015-4e7f-abca1b3902be@iogearbox.net>
 <20181124222012.lcc6hn6vr6xbw7zr@ast-mbp.dhcp.thefacebook.com> <CACAyw98oSS6qbeNCaqukM81V6vWXdrU2HCp2-b++7E=Xnx7e=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw98oSS6qbeNCaqukM81V6vWXdrU2HCp2-b++7E=Xnx7e=w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Y Song <ys114321@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 26, 2018 at 4:45 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> That's what I had initially, but that makes re-using test_attr really
> awkward. Either
> you need to reset data_out_size before every call because it is used
> to return the
> buffer size,

I think that is exactly what the user of the interface would want to do.
Why would anyone keep reusing the same test_attr on multiple calls
into the kernel without changing the fields?

> It also means
> we can't take a const struct attr, which is contrary to the other
> xattr functions which
> already exist.

I don't see an issue with that.

> I think actually inspecting the required size of the output buffer
> will be a rare
> occurrence, so making the user jump through the hoop of a pointer doesn't seem
> too onerous.

I think the opposite is the case.
If the output buffer is provided the test will be comparing it
to expected value.
