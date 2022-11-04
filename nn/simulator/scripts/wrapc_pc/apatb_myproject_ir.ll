; ModuleID = '/local/mtraiola/workspace/accel_39200_500/myproject_prj/solution1/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>" = type { %"struct.ap_fixed_base<16, 8, true, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed_base<16, 8, true, AP_TRN, AP_WRAP, 0>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }

; Function Attrs: noinline
define void @apatb_myproject_ir(%"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="784" %fc1_input, %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="10" %layer7_out) local_unnamed_addr #0 {
entry:
  %fc1_input_copy = alloca [784 x i16], align 512
  %layer7_out_copy = alloca [10 x i16], align 512
  %0 = bitcast %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"* %fc1_input to [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]*
  %1 = bitcast %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"* %layer7_out to [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]*
  call fastcc void @copy_in([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* nonnull %0, [784 x i16]* nonnull align 512 %fc1_input_copy, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* nonnull %1, [10 x i16]* nonnull align 512 %layer7_out_copy)
  %2 = getelementptr [784 x i16], [784 x i16]* %fc1_input_copy, i32 0, i32 0
  %3 = getelementptr [10 x i16], [10 x i16]* %layer7_out_copy, i32 0, i32 0
  call void @apatb_myproject_hw(i16* %2, i16* %3)
  call void @copy_back([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0, [784 x i16]* %fc1_input_copy, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %1, [10 x i16]* %layer7_out_copy)
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_in([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias readonly, [784 x i16]* noalias align 512, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias readonly, [10 x i16]* noalias align 512) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a784struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>.226"([784 x i16]* align 512 %1, [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0)
  call fastcc void @"onebyonecpy_hls.p0a10struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"([10 x i16]* align 512 %3, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a784struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias, [784 x i16]* noalias readonly align 512) unnamed_addr #2 {
entry:
  %2 = icmp eq [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0, null
  %3 = icmp eq [784 x i16]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [784 x i16], [784 x i16]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"], [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i16, i16* %5, align 2
  store i16 %6, i16* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 784
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a10struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"([10 x i16]* noalias align 512, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [10 x i16]* %0, null
  %3 = icmp eq [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"], [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [10 x i16], [10 x i16]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i16, i16* %src.addr.0.0.05, align 2
  store i16 %6, i16* %5, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 10
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_out([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias, [784 x i16]* noalias readonly align 512, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias, [10 x i16]* noalias readonly align 512) unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a784struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0, [784 x i16]* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0a10struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>.220"([10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %2, [10 x i16]* align 512 %3)
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a10struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>.220"([10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias, [10 x i16]* noalias readonly align 512) unnamed_addr #2 {
entry:
  %2 = icmp eq [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0, null
  %3 = icmp eq [10 x i16]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [10 x i16], [10 x i16]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"], [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i16, i16* %5, align 2
  store i16 %6, i16* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 10
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a784struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>.226"([784 x i16]* noalias align 512, [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [784 x i16]* %0, null
  %3 = icmp eq [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"], [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [784 x i16], [784 x i16]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i16, i16* %src.addr.0.0.05, align 2
  store i16 %6, i16* %5, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 784
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

declare void @apatb_myproject_hw(i16*, i16*)

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_back([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias, [784 x i16]* noalias readonly align 512, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* noalias, [10 x i16]* noalias readonly align 512) unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a10struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>.220"([10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %2, [10 x i16]* align 512 %3)
  ret void
}

define void @myproject_hw_stub_wrapper(i16*, i16*) #4 {
entry:
  %2 = alloca [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]
  %3 = alloca [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]
  %4 = bitcast i16* %0 to [784 x i16]*
  %5 = bitcast i16* %1 to [10 x i16]*
  call void @copy_out([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %2, [784 x i16]* %4, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %3, [10 x i16]* %5)
  %6 = bitcast [784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %2 to %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"*
  %7 = bitcast [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %3 to %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"*
  call void @myproject_hw_stub(%"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"* %6, %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"* %7)
  call void @copy_in([784 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %2, [784 x i16]* %4, [10 x %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"]* %3, [10 x i16]* %5)
  ret void
}

declare void @myproject_hw_stub(%"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"*, %"struct.ap_fixed<16, 8, AP_TRN, AP_WRAP, 0>"*)

attributes #0 = { noinline "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #3 = { argmemonly noinline norecurse "fpga.wrapper.func"="copyout" }
attributes #4 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
