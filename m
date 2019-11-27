From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Add prctl support for controlling mem reclaim V4
Date: Wed, 27 Nov 2019 10:07:45 -0800
Message-ID: <24073284-ee53-d22d-dcef-277231283d75@acm.org>
References: <20191112001900.9206-1-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191112001900.9206-1-mchristi@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, linux-api@vger.kernel.org, idryomov@gmail.com, mhocko@kernel.org, david@fromorbit.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, martin@urbackup.org, Damien.LeMoal@wdc.com
Cc: Michal Hocko <mhocko@suse.com>, Masato Suzuki <masato.suzuki@wdc.com>
List-Id: linux-api@vger.kernel.org

On 11/11/19 4:19 PM, Mike Christie wrote:
> There are several storage drivers like dm-multipath, iscsi, tcmu-runner,
> amd nbd that have userspace components that can run in the IO path. For
> example, iscsi and nbd's userspace deamons may need to recreate a socket
> and/or send IO on it, and dm-multipath's daemon multipathd may need to
> send SG IO or read/write IO to figure out the state of paths and re-set
> them up.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
