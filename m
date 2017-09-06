From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Wed, 6 Sep 2017 11:55:30 +0300
Message-ID: <CACVxJT9jWVzXFDZycYGvCPP0GJKgpA1g1u9rrpTeQQPaYNj+eA@mail.gmail.com>
References: <20170905190500.GA13746@avx2> <20170905155320.a683a4853b21a3be32d8b529@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a113f47669046ba0558818177"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905155320.a683a4853b21a3be32d8b529-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tatsiana Brouka <Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--001a113f47669046ba0558818177
Content-Type: text/plain; charset="UTF-8"

On 9/6/17, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, 5 Sep 2017 22:05:00 +0300 Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>
>> Implement system call for bulk retrieveing of pids in binary form.
>>
>> Using /proc is slower than necessary: 3 syscalls + another 3 for each
>> thread +
>> converting with atoi().
>>
>> /proc may be not mounted especially in containers. Natural extension of
>> hidepid=2 efforts is to not mount /proc at all.
>>
>> It could be used by programs like ps, top or CRIU. Speed increase will
>> become more drastic once combined with bulk retrieval of process
>> statistics.
>
> The patches are performance optimizations, but their changelogs contain
> no performance measurements!
>
> Demonstration of some compelling real-world performance benefits would
> help things along a lot.

I forgot the sheet with numbers at work. :^)
They're very embarrassing for /proc.

pidmap:
N=1<<16 times
~130 processes (~250 task_structs) on a regular desktop system
opendir + readdir + closedir /proc + the same for every /proc/$PID/task
(roughly what htop(1) does) vs pidmap

/proc 16.80+-0.73%
pidmap 0.06+-0.31%

fdmap:
N=1<<22 times
4 opened descriptors (0, 1, 2, 3)
opendir+readdir+closedir /proc/self/fd (lsof(1)) vs fdmap

/proc 8.31+-0.37%
fdmap 0.32+-0.72%

Currently performance improvements may not be huge or even visible.
That's because programs like ps/top/lsof _have_ to use /proc to retrieve
other information. If combined with bulk taskstats-ish retrieval interfaces
they should run around /proc.

--001a113f47669046ba0558818177
Content-Type: text/x-csrc; charset="US-ASCII"; name="b-pidmap.c"
Content-Disposition: attachment; filename="b-pidmap.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

I2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPGRpcmVu
dC5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCnZvaWQgZih2b2lk
KQp7CglESVIgKmQ7CglzdHJ1Y3QgZGlyZW50ICpkZTsKCglkID0gb3BlbmRpcigiL3Byb2MvIik7
Cgl3aGlsZSAoKGRlID0gcmVhZGRpcihkKSkpIHsKCQlpZiAoJzEnIDw9IGRlLT5kX25hbWVbMF0g
JiYgZGUtPmRfbmFtZVswXSA8PSAnOScpIHsKCQkJaW50IHBpZCA9IGF0b2koZGUtPmRfbmFtZSk7
CgkJCWNoYXIgYnVmWzMyXTsKCQkJRElSICpkdDsKCQkJc3RydWN0IGRpcmVudCAqZHRlOwoKCQkJ
c25wcmludGYoYnVmLCBzaXplb2YoYnVmKSwgIi9wcm9jLyVkL3Rhc2siLCBwaWQpOwoJCQlkdCA9
IG9wZW5kaXIoYnVmKTsKCQkJcmVhZGRpcihkdCk7CgkJCXJlYWRkaXIoZHQpOwoJCQl3aGlsZSAo
KGR0ZSA9IHJlYWRkaXIoZHQpKSkgewoJCQkJaW50IHRpZCA9IGF0b2koZHRlLT5kX25hbWUpOwoJ
CQkJYXNtIHZvbGF0aWxlICgiIiA6OiAiZyIgKCZ0aWQpIDogIm1lbW9yeSIpOwoJCQl9CgkJCWNs
b3NlZGlyKGR0KTsKCQl9Cgl9CgljbG9zZWRpcihkKTsKfQoKc3RhdGljIGlubGluZSBsb25nIHN5
c19waWRtYXAoaW50ICpwaWQsIHVuc2lnbmVkIGludCBuLCBpbnQgc3RhcnQpCnsKCXJlZ2lzdGVy
IGxvbmcgcjEwIGFzbSAoInIxMCIpID0gMDsKCWxvbmcgcnY7Cglhc20gdm9sYXRpbGUgKAoJCSJz
eXNjYWxsIgoJCTogIj1hIiAocnYpCgkJOiAiMCIgKDMzMyksICJEIiAocGlkKSwgIlMiIChuKSwg
ImQiIChzdGFydCksICJyIiAocjEwKQoJCTogInJjeCIsICJyMTEiLCAiY2MiLCAibWVtb3J5IgoJ
KTsKCXJldHVybiBydjsKfQoKdm9pZCBnKHZvaWQpCnsKCWludCBwaWRbMTAyNF07CgoJc3lzX3Bp
ZG1hcChwaWQsIHNpemVvZihwaWQpL3NpemVvZihwaWRbMF0pLCAwKTsKfQoKaW50IG1haW4odm9p
ZCkKewoJdW5zaWduZWQgaW50IGk7CgovLwlmb3IgKGkgPSAwOyBpIDwgKDE8PDE2KTsgaSsrKQov
LwkJZigpOwoKCWZvciAoaSA9IDA7IGkgPCAoMTw8MTYpOyBpKyspCgkJZygpOwoKCXJldHVybiAw
Owp9Cg==
--001a113f47669046ba0558818177
Content-Type: text/x-csrc; charset="US-ASCII"; name="b-fdmap.c"
Content-Disposition: attachment; filename="b-fdmap.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: file2

I2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8ZGlyZW50Lmg+CiNpbmNsdWRlIDxzdGRs
aWIuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKdm9pZCBmKHZvaWQpCnsKCURJUiAqZDsKCXN0cnVj
dCBkaXJlbnQgKmRlOwoKCWQgPSBvcGVuZGlyKCIvcHJvYy9zZWxmL2ZkIik7Cgl3aGlsZSAoKGRl
ID0gcmVhZGRpcihkKSkpIHsKCQlpbnQgZmQgPSBhdG9pKGRlLT5kX25hbWUpOwoJCWFzbSB2b2xh
dGlsZSAoIiIgOjogImciICgmZmQpIDogIm1lbW9yeSIpOwoJfQoJY2xvc2VkaXIoZCk7Cn0KCnN0
YXRpYyBpbmxpbmUgbG9uZyBzeXNfZmRtYXAoaW50IHBpZCwgaW50ICpmZCwgdW5zaWduZWQgaW50
IG4sIGludCBzdGFydCkKewoJcmVnaXN0ZXIgbG9uZyByMTAgYXNtICgicjEwIikgPSBzdGFydDsK
CXJlZ2lzdGVyIGxvbmcgcjggYXNtICgicjgiKSA9IDA7Cglsb25nIHJ2OwoJYXNtIHZvbGF0aWxl
ICgKCQkic3lzY2FsbCIKCQk6ICI9YSIgKHJ2KQoJCTogIjAiICgzMzQpLCAiRCIgKHBpZCksICJT
IiAoZmQpLCAiZCIgKG4pLCAiciIgKHIxMCksICJyIiAocjgpCgkJOiAicmN4IiwgInIxMSIsICJj
YyIsICJtZW1vcnkiCgkpOwoJcmV0dXJuIHJ2Owp9Cgp2b2lkIGcodm9pZCkKewoJaW50IGZkWzEw
MjRdOwoKCXN5c19mZG1hcCgwLCBmZCwgc2l6ZW9mKGZkKS9zaXplb2YoZmRbMF0pLCAwKTsKfQoK
aW50IG1haW4odm9pZCkKewoJdW5zaWduZWQgaW50IGk7CgovLwlmb3IgKGkgPSAwOyBpIDwgKDE8
PDIyKTsgaSsrKQovLwkJZigpOwoKCWR1cCgwKTsKCWZvciAoaSA9IDA7IGkgPCAoMTw8MjIpOyBp
KyspCgkJZygpOwoKCXJldHVybiAwOwp9Cg==
--001a113f47669046ba0558818177--
