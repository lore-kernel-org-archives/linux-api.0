From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 1/3] bpf: allow zero-initializing hash map seed
Date: Mon, 8 Oct 2018 10:48:29 +0100
Message-ID: <CACAyw98ZikQHU7VHnioUi6tXX5tq9+UyGS5+zQjF_6wJ1tHRqw@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181001104509.24211-2-lmb@cloudflare.com>
 <CAG48ez0_BtXQ2KCgpRicQ8yfeNqV2mN8RKCA3nn8DXFTmsj6UA@mail.gmail.com>
 <CACAyw99ar0Wokyg4jx8FPyr1Z=7Cf+=WVgF6sLL1FK9JtHROjw@mail.gmail.com>
 <CAG48ez3wwGgc40uAg5nq9dnC3qsAD04jQZTWtPi7jg_VDws-fg@mail.gmail.com>
 <CACAyw9-JcORMGDb3wm-E4VYmjVmvWqB5vVh+=qTvXmpFWye_QA@mail.gmail.com>
 <CAG48ez0+1k90oK2qrwbg0HAWF=eSocZee=Mi75E_7UY0u7TGJg@mail.gmail.com> <20181005210732.ft77r5qqcoqpiwu7@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181005210732.ft77r5qqcoqpiwu7@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jann Horn <jannh@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 5 Oct 2018 at 22:07, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 05, 2018 at 04:27:58PM +0200, Jann Horn wrote:
> >
> > Can you please describe exactly why something that is not a kernel
> > unit test needs deterministic BPF hash map behavior?
>
> my use case for deterministic hashing is performance analysis.
> Both while developing and tuning bpf program and while optimizing
> kernel side implementation.
> Local dos is a valid concern, so requiring root for this flag makes sense.
>

Ok, I'll respin and address the comments.

-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
