From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v4 3/4] libbpf: add bpf_prog_test_run_xattr
Date: Fri, 30 Nov 2018 13:21:47 -0800
Message-ID: <20181130212144.x6ffe2ytr3f3ucrm@ast-mbp.dhcp.thefacebook.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181128165312.19500-1-lmb@cloudflare.com>
 <20181128165312.19500-4-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128165312.19500-4-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com
List-Id: linux-api@vger.kernel.org

On Wed, Nov 28, 2018 at 04:53:11PM +0000, Lorenz Bauer wrote:
> Add a new function, which encourages safe usage of the test interface.
> bpf_prog_test_run continues to work as before, but should be considered
> unsafe.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
..
> +
> +LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);

it fails to be build due to:
  LINK     tools/testing/selftests/bpf/test_libbpf
(117) does NOT match with num of versioned symbols in testing/selftests/bpf/libbpf.so (116).
Please make sure all LIBBPF_API symbols are versioned in libbpf.map.

Please fixup and respin.
The rest looks good.
