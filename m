From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v5 0/4] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Tue, 4 Dec 2018 08:22:10 -0800
Message-ID: <20181204162208.tn4ljbiqtby6pc52@ast-mbp.dhcp.thefacebook.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181203113126.2591-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181203113126.2591-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 03, 2018 at 11:31:22AM +0000, Lorenz Bauer wrote:
> Right now, there is no safe way to use BPF_PROG_TEST_RUN with data_out.
> This is because bpf_test_finish copies the output buffer to user space
> without checking its size. This can lead to the kernel overwriting
> data in user space after the buffer if xdp_adjust_head and friends are
> in play.
> 
> Thanks to everyone for their advice and patience with this patch set!
> 
> Changes in v5:
> * Fix up libbpf.map
> 
> Changes in v4:
> * Document bpf_prog_test_run and bpf_prog_test_run_xattr
> * Use struct bpf_prog_test_run_attr for return values
> 
> Changes in v3:
> * Introduce bpf_prog_test_run_xattr instead of modifying the existing
>   function
> 
> Changes in v2:
> * Make the syscall return ENOSPC if data_size_out is too small
> * Make bpf_prog_test_run return EINVAL if size_out is missing
> * Document the new behaviour of data_size_out

Applied, Thanks
