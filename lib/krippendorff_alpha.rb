require 'matrix'
require 'ffi'
require 'ffi-compiler/loader'

module KrippendorffAlphaLib
  extend FFI::Library

  ffi_lib FFI::Library::LIBC

  # memory allocators
  attach_function :malloc, [:size_t], :pointer
  attach_function :calloc, [:size_t], :pointer
  attach_function :valloc, [:size_t], :pointer
  attach_function :realloc, [:pointer, :size_t], :pointer
  attach_function :free, [:pointer], :void

  # memory movers
  attach_function :memcpy, [:pointer, :pointer, :size_t], :pointer
  attach_function :bcopy, [:pointer, :pointer, :size_t], :void

  ffi_lib FFI::Compiler::Loader.find('krippendorff_alpha')
  attach_function :_krippendorff_alpha, [:pointer, :size_t, :size_t, :pointer, :size_t, :pointer, :size_t], :double
end

module KrippendorffAlpha
  include KrippendorffAlphaLib

  # Calculate Krippendorff's alpha (inter-rater reliability)
  # http://repository.upenn.edu/cgi/viewcontent.cgi?article=1043&context=asc_papers
  #
  # Assumed input (Matrix)
  # [
  #   [ nil, nil, nil, nil, nil, 3, 4, 1, 2, 1, 1, 3, 3, nil, 3 ],    # coder 1
  #   [ 1, nil, 2, 1, 3, 3, 4, 3, nil, nil, nil, nil, nil, nil, nil], # coder 2
  #   [ nil, nil, 2, 1, 3, 4, 4, nil, 2, 1, 1, 3, 3, nil, 4 ]         # coder 3
  # ]
  def krippendorff_alpha
    in_array = self.to_a
    in_array_flattened = in_array.transpose.flatten
    unique_values = in_array.flatten.compact.uniq

    # We need to keep track of the skip indexes separately since we can't send nils via C array of double
    skip_indexes = []
    in_array_flattened.each_with_index do |element, i|
      skip_indexes << i if element.nil?
    end

    # Reformat the in_array to not have nil
    skip_indexes.each {|i| in_array_flattened[i] = 0 }

    FFI::MemoryPointer.new(:double, in_array_flattened.size) do |in_array_ptr|
      FFI::MemoryPointer.new(:double, unique_values.size) do |unique_values_ptr|
        FFI::MemoryPointer.new(:int, skip_indexes.size) do |skip_indexes_ptr|
          in_array_ptr.write_array_of_double(in_array_flattened)
          unique_values_ptr.write_array_of_double(unique_values)
          skip_indexes_ptr.write_array_of_int(skip_indexes)

          return _krippendorff_alpha(in_array_ptr, row_count, column_count, skip_indexes_ptr, skip_indexes.size, unique_values_ptr, unique_values.size)
        end
      end
    end
  end
end

Matrix.send(:include, KrippendorffAlpha)
