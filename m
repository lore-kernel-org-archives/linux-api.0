From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 0/3] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Mon, 19 Nov 2018 14:30:04 +0000
Message-ID: <CACAyw98fu_=WufBrv_7CwO4iJj3jhOu1n6b3Pr0aZxqSk8++Gw@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com> <CAH3MdRW1=iUm0qQdNrv9r5Orn3rZ2XBDn-qym5i_cpi7wo6PxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAH3MdRW1=iUm0qQdNrv9r5Orn3rZ2XBDn-qym5i_cpi7wo6PxA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: ys114321@gmail.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 18 Nov 2018 at 06:13, Y Song <ys114321@gmail.com> wrote:
>
> There is a slight change of user space behavior for this patch.
> Without this patch, the value bpf_attr.test.data_size_out is output only.
> For example,
>    output buffer : out_buf (user allocated size 10)
>    data_size_out is a random value (e.g., 1),
>
> The actual data to copy is 5.
>
> In today's implementation, the kernel will copy 5 and set data_size_out is 5.
>
> With this patch, the kernel will copy 1 and set data_size_out is 5.
>
> I am not 100% sure at this time whether we CAN overload data_size_out
> since it MAY break existing applications.

Yes, that's correct. I think that the likelihood of this is low. It would
affect code that uses bpf_attr without zeroing it first. I had a look around,
and I could only find code that would keep working:

* kernel libbpf and descendants (e.g katran)
* github.com/iovisor/gobpf
* github.com/newtools/ebpf

That doesn't really guarantee anything of course.


-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
