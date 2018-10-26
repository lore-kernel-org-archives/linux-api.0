From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 03/10] audit: log container info of
 syscalls
Date: Fri, 26 Oct 2018 01:09:16 -0700
Message-ID: <e1d8a8cf-5013-ffbe-923b-604851de836d@schaufler-ca.com>
References: <cover.1533065887.git.rgb@redhat.com>
 <34017c395d03a213d6b0d49b9964429bd32b283d.1533065887.git.rgb@redhat.com>
 <CAHC9VhSv4hWGHiaaOfuBrRQKdp2YG5RtqXQbFXg7j7LNEhO2XQ@mail.gmail.com>
 <20181024151439.lavhanabsyxdrdvo@madcap2.tricolour.ca>
 <CAHC9VhRF1vsxM-k0Lw-9NqS9b9rgXRRBu0tq4ajdFpMqUxiH4A@mail.gmail.com>
 <20181025004255.zl7p7j6gztouh2hh@madcap2.tricolour.ca>
 <20181025080638.771621a3@ivy-bridge>
 <CAHC9VhR02siURgadQs0EikcOm0d_TPAi4jJYCx4NkA=wQ5rjSA@mail.gmail.com>
 <20181025122732.4j4rbychjse3gemt@madcap2.tricolour.ca>
 <20181025175745.5b2b13e9@ivy-bridge>
 <20181025173830.4yklhnrydt5qvr67@madcap2.tricolour.ca>
 <CAHC9VhScaG8aOFYRV5hPXEKob1QRth5YFEbHNY=ZgKKAKxBBsQ@mail.gmail.com>
 <20181025235527.15a39d75@ivy-bridge>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025235527.15a39d75@ivy-bridge>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>, Paul Moore <paul@paul-moore.com>
Cc: luto@kernel.org, rgb@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dhowells@redhat.com, carlos@redhat.com, linux-audit@redhat.com, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 10/25/2018 2:55 PM, Steve Grubb wrote:
> ...
> And historically speaking setting audit loginuid produces a LOGIN
> event, so it only makes sense to consider binding container ID to
> container as a CONTAINER event. For other supplemental records, we name
> things what they are: PATH, CWD, SOCKADDR, etc. So, CONTAINER_ID makes
> sense. CONTAINER_OP sounds like its for operations on a container. Do
> we have any operations on a container?

The answer has to be "no", because containers are, by emphatic assertion,
not kernel constructs. Any CONTAINER_OP event has to come from user space.
I think.
