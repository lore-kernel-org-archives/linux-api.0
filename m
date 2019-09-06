From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Date: Fri, 6 Sep 2019 10:22:51 -0700
Message-ID: <CAADnVQ+D9JTgqMbx4mfX-9ShpLEdzKpxf1R4Sq9r5-bH+aADZg@mail.gmail.com>
References: <20190904184335.360074-2-ast@kernel.org> <201909070002.v6gbdPOK%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201909070002.v6gbdPOK%lkp@intel.com>
Sender: netdev-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>, kbuild-all@01.org, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 6, 2019 at 9:21 AM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Alexei,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Alexei-Starovoitov/capability-introduce-CAP_BPF-and-CAP_TRACING/20190906-215814
> base:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-11) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    kernel//bpf/syscall.c: In function 'bpf_prog_test_run':
> >> kernel//bpf/syscall.c:2087:6: warning: the address of 'capable_bpf_net_admin' will always evaluate as 'true' [-Waddress]
>      if (!capable_bpf_net_admin)
>          ^

argh. fixing and rebasing.
