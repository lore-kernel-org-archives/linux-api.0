From: =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Subject: [PATCH] uapi elf: delete unused macros
Date: Thu, 5 Nov 2015 22:54:34 +0800
Message-ID: <CAD-N9QU=C0dMN50F67GihvTBikUVmF4uSGvj=nZZfJpeum+=1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3122139937888910795=="
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, takahiro.akashi@linaro.org, will.deacon@arm.com
Cc: linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

--===============3122139937888910795==
Content-Type: multipart/alternative; boundary=001a11c36c46e605890523cc4fa0

--001a11c36c46e605890523cc4fa0
Content-Type: text/plain; charset=UTF-8

delete unused macros and unify the comment format

>From e21328f3450e841abf8a312865910806d0858373 Mon Sep 17 00:00:00 2001
From: mudongliang <mudongliangabcd@gmail.com>
Date: Thu, 5 Nov 2015 22:46:19 +0800
Subject: [PATCH] unify the comment form and delete unused macros

Signed-off-by: mudongliang <mudongliangabcd@gmail.com>
---
 arch/powerpc/boot/elf.h  | 6 ++----
 include/uapi/linux/elf.h | 7 ++-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/boot/elf.h b/arch/powerpc/boot/elf.h
index 1941bc5..e6e00ed 100644
--- a/arch/powerpc/boot/elf.h
+++ b/arch/powerpc/boot/elf.h
@@ -133,15 +133,13 @@ typedef struct elf64_phdr {
 #define ELFCLASSNONE 0 /* EI_CLASS */
 #define ELFCLASS32 1
 #define ELFCLASS64 2
-#define ELFCLASSNUM 3

-#define ELFDATANONE 0 /* e_ident[EI_DATA] */
+#define ELFDATANONE 0 /* EI_DATA */
 #define ELFDATA2LSB 1
 #define ELFDATA2MSB 2

-#define EV_NONE 0 /* e_version, EI_VERSION */
+#define EV_NONE 0 /* EI_VERSION */
 #define EV_CURRENT 1
-#define EV_NUM 2

 #define ELFOSABI_NONE 0
 #define ELFOSABI_LINUX 3
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 71e1d0e..bd049b2 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -342,15 +342,12 @@ typedef struct elf64_shdr {
 #define ELFCLASSNONE 0 /* EI_CLASS */
 #define ELFCLASS32 1
 #define ELFCLASS64 2
-#define ELFCLASSNUM 3

-#define ELFDATANONE 0 /* e_ident[EI_DATA] */
+#define ELFDATANONE 0 /* EI_DATA */
 #define ELFDATA2LSB 1
-#define ELFDATA2MSB 2

-#define EV_NONE 0 /* e_version, EI_VERSION */
+#define EV_NONE 0 /* EI_VERSION */
 #define EV_CURRENT 1
-#define EV_NUM 2

 #define ELFOSABI_NONE 0
 #define ELFOSABI_LINUX 3
-- 
2.1.4

-- 
My best regards to you.

     No System Is Safe!
     mudongliang

--001a11c36c46e605890523cc4fa0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>delete unused macros and unify the comment format</di=
v><div><br></div><div>From e21328f3450e841abf8a312865910806d0858373 Mon Sep=
 17 00:00:00 2001</div><div>From: mudongliang &lt;<a href=3D"mailto:mudongl=
iangabcd@gmail.com">mudongliangabcd@gmail.com</a>&gt;</div><div>Date: Thu, =
5 Nov 2015 22:46:19 +0800</div><div>Subject: [PATCH] unify the comment form=
 and delete unused macros</div><div><br></div><div>Signed-off-by: mudonglia=
ng &lt;<a href=3D"mailto:mudongliangabcd@gmail.com">mudongliangabcd@gmail.c=
om</a>&gt;</div><div>---</div><div>=C2=A0arch/powerpc/boot/elf.h =C2=A0| 6 =
++----</div><div>=C2=A0include/uapi/linux/elf.h | 7 ++-----</div><div>=C2=
=A02 files changed, 4 insertions(+), 9 deletions(-)</div><div><br></div><di=
v>diff --git a/arch/powerpc/boot/elf.h b/arch/powerpc/boot/elf.h</div><div>=
index 1941bc5..e6e00ed 100644</div><div>--- a/arch/powerpc/boot/elf.h</div>=
<div>+++ b/arch/powerpc/boot/elf.h</div><div>@@ -133,15 +133,13 @@ typedef =
struct elf64_phdr {</div><div>=C2=A0#define<span class=3D"" style=3D"white-=
space:pre">	</span>ELFCLASSNONE<span class=3D"" style=3D"white-space:pre">	=
</span>0<span class=3D"" style=3D"white-space:pre">	</span>/* EI_CLASS */</=
div><div>=C2=A0#define<span class=3D"" style=3D"white-space:pre">	</span>EL=
FCLASS32<span class=3D"" style=3D"white-space:pre">	</span>1</div><div>=C2=
=A0#define<span class=3D"" style=3D"white-space:pre">	</span>ELFCLASS64<spa=
n class=3D"" style=3D"white-space:pre">	</span>2</div><div>-#define<span cl=
ass=3D"" style=3D"white-space:pre">	</span>ELFCLASSNUM<span class=3D"" styl=
e=3D"white-space:pre">	</span>3</div><div>=C2=A0</div><div>-#define ELFDATA=
NONE<span class=3D"" style=3D"white-space:pre">	</span>0<span class=3D"" st=
yle=3D"white-space:pre">	</span>/* e_ident[EI_DATA] */</div><div>+#define E=
LFDATANONE<span class=3D"" style=3D"white-space:pre">	</span>0<span class=
=3D"" style=3D"white-space:pre">	</span>/* EI_DATA */</div><div>=C2=A0#defi=
ne ELFDATA2LSB<span class=3D"" style=3D"white-space:pre">	</span>1</div><di=
v>=C2=A0#define ELFDATA2MSB<span class=3D"" style=3D"white-space:pre">	</sp=
an>2</div><div>=C2=A0</div><div>-#define EV_NONE<span class=3D"" style=3D"w=
hite-space:pre">		</span>0<span class=3D"" style=3D"white-space:pre">	</spa=
n>/* e_version, EI_VERSION */</div><div>+#define EV_NONE<span class=3D"" st=
yle=3D"white-space:pre">		</span>0<span class=3D"" style=3D"white-space:pre=
">	</span>/* EI_VERSION */</div><div>=C2=A0#define EV_CURRENT<span class=3D=
"" style=3D"white-space:pre">	</span>1</div><div>-#define EV_NUM<span class=
=3D"" style=3D"white-space:pre">		</span>2</div><div>=C2=A0</div><div>=C2=
=A0#define ELFOSABI_NONE<span class=3D"" style=3D"white-space:pre">	</span>=
0</div><div>=C2=A0#define ELFOSABI_LINUX<span class=3D"" style=3D"white-spa=
ce:pre">	</span>3</div><div>diff --git a/include/uapi/linux/elf.h b/include=
/uapi/linux/elf.h</div><div>index 71e1d0e..bd049b2 100644</div><div>--- a/i=
nclude/uapi/linux/elf.h</div><div>+++ b/include/uapi/linux/elf.h</div><div>=
@@ -342,15 +342,12 @@ typedef struct elf64_shdr {</div><div>=C2=A0#define<s=
pan class=3D"" style=3D"white-space:pre">	</span>ELFCLASSNONE<span class=3D=
"" style=3D"white-space:pre">	</span>0<span class=3D"" style=3D"white-space=
:pre">		</span>/* EI_CLASS */</div><div>=C2=A0#define<span class=3D"" style=
=3D"white-space:pre">	</span>ELFCLASS32<span class=3D"" style=3D"white-spac=
e:pre">	</span>1</div><div>=C2=A0#define<span class=3D"" style=3D"white-spa=
ce:pre">	</span>ELFCLASS64<span class=3D"" style=3D"white-space:pre">	</spa=
n>2</div><div>-#define<span class=3D"" style=3D"white-space:pre">	</span>EL=
FCLASSNUM<span class=3D"" style=3D"white-space:pre">	</span>3</div><div>=C2=
=A0</div><div>-#define ELFDATANONE<span class=3D"" style=3D"white-space:pre=
">	</span>0<span class=3D"" style=3D"white-space:pre">		</span>/* e_ident[E=
I_DATA] */</div><div>+#define ELFDATANONE<span class=3D"" style=3D"white-sp=
ace:pre">	</span>0<span class=3D"" style=3D"white-space:pre">		</span>/* EI=
_DATA */</div><div>=C2=A0#define ELFDATA2LSB<span class=3D"" style=3D"white=
-space:pre">	</span>1</div><div>-#define ELFDATA2MSB<span class=3D"" style=
=3D"white-space:pre">	</span>2</div><div>=C2=A0</div><div>-#define EV_NONE<=
span class=3D"" style=3D"white-space:pre">		</span>0<span class=3D"" style=
=3D"white-space:pre">		</span>/* e_version, EI_VERSION */</div><div>+#defin=
e EV_NONE<span class=3D"" style=3D"white-space:pre">		</span>0<span class=
=3D"" style=3D"white-space:pre">		</span>/* EI_VERSION */</div><div>=C2=A0#=
define EV_CURRENT<span class=3D"" style=3D"white-space:pre">	</span>1</div>=
<div>-#define EV_NUM<span class=3D"" style=3D"white-space:pre">		</span>2</=
div><div>=C2=A0</div><div>=C2=A0#define ELFOSABI_NONE<span class=3D"" style=
=3D"white-space:pre">	</span>0</div><div>=C2=A0#define ELFOSABI_LINUX<span =
class=3D"" style=3D"white-space:pre">	</span>3</div><div>--=C2=A0</div><div=
>2.1.4</div><div><br></div>-- <br><div class=3D"gmail_signature"><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">My best regards to you=
.<span style=3D"color:rgb(17,17,17);font-family:Helvetica,Arial,sans-serif;=
font-size:12px;line-height:19.44px"><br></span></div><div dir=3D"ltr"><span=
 style=3D"color:rgb(17,17,17);font-family:Helvetica,Arial,sans-serif;font-s=
ize:12px;line-height:19.44px"><br></span></div><div dir=3D"ltr"><span style=
=3D"color:rgb(17,17,17);font-family:Helvetica,Arial,sans-serif;font-size:12=
px;line-height:19.44px">=C2=A0 =C2=A0 =C2=A0No System Is Safe!</span><div><=
span style=3D"color:rgb(17,17,17);font-family:Helvetica,Arial,sans-serif;fo=
nt-size:12px;line-height:19.44px">=C2=A0 =C2=A0 =C2=A0mudongliang</span></d=
iv></div></div></div></div></div></div>
</div>

--001a11c36c46e605890523cc4fa0--

--===============3122139937888910795==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXhwcGMt
ZGV2IG1haWxpbmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRwczovL2xp
c3RzLm96bGFicy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2

--===============3122139937888910795==--
