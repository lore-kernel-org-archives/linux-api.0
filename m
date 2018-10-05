From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 1/3] bpf: allow zero-initializing hash map seed
Date: Fri, 5 Oct 2018 08:42:22 +0100
Message-ID: <CACAyw99ar0Wokyg4jx8FPyr1Z=7Cf+=WVgF6sLL1FK9JtHROjw@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181001104509.24211-2-lmb@cloudflare.com>
 <CAG48ez0_BtXQ2KCgpRicQ8yfeNqV2mN8RKCA3nn8DXFTmsj6UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0_BtXQ2KCgpRicQ8yfeNqV2mN8RKCA3nn8DXFTmsj6UA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: jannh@google.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2 Oct 2018 at 21:00, Jann Horn <jannh@google.com> wrote:
>
> If this is for testing only, you can slap a capable(CAP_SYS_ADMIN)
> check in here, right? I doubt it matters, but I don't really like
> seeing something like this exposed to unprivileged userspace just
> because you need it for kernel testing.

That would mean all tests have to run as root / with CAP_SYS_ADMIN
which isn't ideal.

-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
